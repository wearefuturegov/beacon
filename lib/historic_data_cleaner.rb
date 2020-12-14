# frozen_string_literal: true

class HistoricDataCleaner
  BATCH_SIZE = 5
  DOUBLE_LINE = '================================================='
  FAILURE = '❌'
  LINE = '------------------------------------'
  PASS = '✅'

  def self.call(object, caller, fields_to_update)
    new(object, caller, fields_to_update)
  end

  attr_reader :multi_logger

  def initialize(object, caller, fields_to_update)
    self.caller = caller
    @environment_log_message = environment_log_message
    @fields_to_update = fields_to_update
    @object_name = object
    @multi_logger = create_logger
    @object_statement = []
    @updated_records = []
    @invalid_records = []
    @processed_count = 0
    @updated_count = 0
    @not_updated_count = 0
  end

  def cleanse
    log_start
    validate_object
    build_object_statement
    validate_object_statement
    process_in_batches
    report_success_and_errors
  end

  private

  attr_accessor :object_statement, :updated_records, :invalid_records, :processed_count, :updated_count, :not_updated_count
  attr_reader :fields_to_update, :object

  def caller=(caller)
    @caller = caller.include?(':') ? caller.split(':').join('_') : caller
  end

  def environment_log_message
    case Rails.env
    when 'development'
      "\e[1m\e[32m#{Rails.env.upcase}\e[0m"
    when 'test'
      "\e[36m#{Rails.env.upcase}\e[0m"
    when 'production'
      "\e[31mCAUTION: \u001b[4m\e[0;101m\e[1;97mPRODUCTION\e[0m"
    else
      "\e[1;33mWARN: \e[1m\e[1;33m#{Rails.env.upcase}\e[0m"
    end
  end

  def create_logger
    stdout_logger = ActiveSupport::Logger.new(STDOUT)
    file_logger = ActiveSupport::Logger.new("log/#{@caller}_#{@object_name}_#{Rails.env}.log")
    multi_logger = stdout_logger.extend(ActiveSupport::Logger.broadcast(file_logger))
    multi_logger.level = Logger::INFO

    original_formatter = Logger::Formatter.new
    file_logger.formatter = proc { |severity, datetime, progname, msg|
      original_formatter.call(severity, datetime, progname, msg)
    }
    multi_logger
  end

  def log_start
    log "\u001b[0m\u001b[7m ENVIRONMENT ** \e[0m #{environment_log_message} \u001b[0m\u001b[7m ** ENVIRONMENT \e[0m\n"
    log "#{Time.now}  \e[1m\e[33m__START__\e[0m"
    msg = "Processing Data Cleanup Request for #{@object_name.capitalize}s"
    log msg
    puts DOUBLE_LINE
  end

  def log(msg, status = :info)
    severity = Object.const_get("#{Logger}::#{status.to_s.upcase}")
    multi_logger.add(severity, msg, self.class.name)
  end

  def validate_object
    @object = @object_name.to_s.classify.constantize
  rescue NameError => e
    log("#{e.class}: #{e.message}", :fatal)
    log("\e[31mPlease check the name of the model/table is correct - Exiting\e[0m")
    exit 90
  end

  def build_object_statement
    log "Fields/columns/attributes - targeted\n#{LINE}"
    fields_to_update.each do |field|
      log field
      object_statement << "LENGTH(RTRIM(LTRIM(#{field}))) <> LENGTH(#{field})"
    end
    puts LINE + "\n"
  end

  def validate_object_statement
    valid_fields = object.attribute_names.select { |name| [:string, :text].include?(object.type_for_attribute(name).type) }
    invalid_fields = fields_to_update - valid_fields
    return unless invalid_fields.any?

    log('ActiveRecord::InvalidStatement would be raised', :fatal)
    invalid_fields.each do |field|
      log("column \e[31m#{@object_name}.#{field}\e[0m does not exist")
    end
    log("\e[31mPlease check the name of the fields are correct - Exiting\e[0m")
    exit 95
  end

  def process_in_batches
    temp_updated_records = []
    log "BATCH_SIZE: #{BATCH_SIZE}\n#{LINE}"

    # Process in batches set by the batch size 1000 is default.
    object
      .where(object_statement.join(' OR '))
      .find_in_batches(batch_size: BATCH_SIZE)
      .with_index do |group, batch|
        temp_updated_records = []
        msg = "\nProcessing batch #{batch} (#{group.size} records)"
        print msg
        msg = '.'

        group.each do |record|
          if record.save(touch: false)
            @updated_count += 1
            temp_updated_records << record.id
            print "\e[32m#{msg}\e[0m"
          else
            @not_updated_count += 1
            @invalid_records << "#{record.id} - #{record.errors.full_messages.to_sentence}"
            print "\e[31mx\e[0m"
          end
          @processed_count += 1
        end
        @updated_records << temp_updated_records
      end
  end

  def report_success_and_errors
    if updated_records.empty?
      log "\nZERO records!\n"
    else
      log "\n#{LINE}\nTotal Records Processed: #{processed_count}"
      log "Updated #{PASS} #{updated_count}"

      if not_updated_count.positive?
        log "Errors #{FAILURE} #{not_updated_count}"
        log "#{LINE}\nError Records ID & reason\n#{invalid_records.split.join("\n")}"
      end
      unless updated_records.flatten.empty?
        log "#{LINE}\nUpdated Record ID's: \n"
        log updated_records.map(&:to_s)
      end
    end
    log "\n#{Time.now}  \e[1m\e[33m__END__\e[0m\n"
  end
end
