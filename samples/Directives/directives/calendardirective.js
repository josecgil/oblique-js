
Oblique().registerDirective(
    "CalendarDirective",
    function (data) {
        console.log(data.domElement);
        console.log("Initial Date:"+ data.params.initialDate);
    }
);
