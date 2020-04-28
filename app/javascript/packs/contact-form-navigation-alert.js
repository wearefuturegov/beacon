$(() => {
   $("body").attr("data-turbolinks", false);

   const formElement = $("form.contact-form");
   const originalState = formElement.serialize();
   formElement.on("submit", onSubmit)

   function shouldNavigateDirectly() {
      const currentState = $("form").serialize();

      $("*").blur();
      return currentState === originalState ? undefined : false;
   };

   function onSubmit() {
      $(window).off("beforeunload", shouldNavigateDirectly);
   }

   $(window).on("beforeunload", shouldNavigateDirectly);
})



