const descriptionPromptLabel = document.querySelector('label[for=note_description]');
const leftMessageQuestionSection = document.getElementById('left_message_question_section');
const noteDescriptionSection = document.getElementById('note_description_section');

let failure_reason = null;
let left_message = null;

const onFailureReasonRadioChanged = (el) => {
    failure_reason = el.target.value;
    updateFromState();
};

const onLeftMessageRadioChanged = (el) => {
    left_message = el.target.value === 'Yes';
    updateFromState();
};

const updateFromState = () => {
    if (failure_reason === 'call_not_answered') {
        leftMessageQuestionSection.hidden = false;
        noteDescriptionSection.hidden = left_message === null;
        if (left_message === true) descriptionPromptLabel.textContent = "What did you say in the message?";
        else if (left_message === false) descriptionPromptLabel.textContent = "Why didn't you leave a message?";
        return;
    }

    leftMessageQuestionSection.hidden = true;
    noteDescriptionSection.hidden = false;

    if (failure_reason === 'incorrect_or_missing') descriptionPromptLabel.textContent = "Describe the missing or invalid contact details";
    else if (failure_reason === 'other') descriptionPromptLabel.textContent = "Describe the reason for the failed assessment attempt";
};



Array.from(document.forms.assessment_failure_form.failure_reason).forEach(el => el.addEventListener('change', onFailureReasonRadioChanged));
Array.from(document.forms.assessment_failure_form.left_message).forEach(el => el.addEventListener('change', onLeftMessageRadioChanged));