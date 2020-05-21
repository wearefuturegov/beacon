

function hideOtherRows(id){
  let rows = $("#open-assessments-table > tbody > tr").toArray();
  rows.forEach((row)=>{
    let data = row.getAttribute("data");
    if(data==id){
      row.className = "need--" + data
    } else {
      row.className = "need--hide";
    }
  });
}

$(document).ready(function() {
    $('.tablink').each(function() {
      $(this).click(function(){
        const id = $(this).attr('id');
        let tablinks = document.getElementsByClassName("tablink");
        for (let i = 0; i < tablinks.length; i++) {
          tablinks[i].className = "tablink";
          if(id == tablinks[i].id){
            tablinks[i].className += " tablink__active";
            hideOtherRows(id);
          }
        }    
      })
  });

  $('.tablink').first().click();
});