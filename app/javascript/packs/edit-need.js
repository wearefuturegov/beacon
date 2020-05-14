const flatpickr = require('flatpickr')
$( document ).ready(function() {
  let editNeedBtn = 'edit-need-btn'
  let editNeedSaveBtn = 'save-edit-need'
  let editNeedActionsButtons = ['cancel-edit-need', editNeedSaveBtn]
  let showEditNeedActionsButtons = () => {
      for(let i = 0; i < editNeedActionsButtons.length; i++) 
        $(`#${editNeedActionsButtons[i]}`).css("display", "inline-block")
  }

  let editableTextsElems = ['show-need-description p', 'show-need-food-priority', 'show-need-food-service-type']  
  let makeTextElemsEditable = () => {
    for(let i = 0; i < editableTextsElems.length; i++) {
      let elem = $(`#${editableTextsElems[i]}`)[0]
      elem && elem.setAttribute("contentEditable", true)
    }
  }
  
  let makeStartOnEditable = () => {
    $('#show-need-start-on').hide()
    let showNeedStartOnFlatPickr = flatpickr('#show-need-start-on', {
        dateFormat: "d/m/Y",
        allowInput: true, 
        defaultDate: [$('#show-need-start-on-flatpicker_format').val()]
    });
  }
  
  function startNeedEditableMode() {
    $(`#${editNeedBtn}`).css("display", "none")
    showEditNeedActionsButtons()
    makeTextElemsEditable()
    makeStartOnEditable()
  }
  
  $(`#${editNeedBtn}`).click(() => startNeedEditableMode())
  
  $(`#${editNeedSaveBtn}`).click(() => {
    console.log('show-need-start-on')
    console.log($('#show-need-start-on').val())
    editableTextsElems.forEach((e) => {
    //   if(e == '')
    //   console.log(e)
      console.log($(`#${e}`).html())
    })
  })
});
