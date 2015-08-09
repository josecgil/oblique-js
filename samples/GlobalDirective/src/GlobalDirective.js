var GlobalDirective=function (data) {
    alert("I'm a global Directive");
    alert(data.domElement);
};

Oblique().registerDirectiveAsGlobal("GlobalDirective", GlobalDirective);