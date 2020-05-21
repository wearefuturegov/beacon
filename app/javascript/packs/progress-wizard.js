class ProgressWizard {
    constructor() {
        this.steps = $(".progress-wizard li");
    }

    markCallCurrent() {
        this._markStepCurrent("make-call");
    }

    markTriageCurrent() {

    }

    markAssignCurrent() {

    }

    markCompleteCurrent() {

    }

    _findStep(stepName) {
        return this.steps.filter(`[data-step='${stepName}']`);
    }

    _markStepCurrent(stepName) {
        const currentStep = this._findStep(stepName);
        currentStep.addClass("current-step");
    }

    _markStepComplete(stepName) {
        const currentStep = this._findStep(stepName);
        currentStep.find("span .indicator.completed").removeClass("invisible")
    }

    _markStepFailed(stepName) {
        const currentStep = this._findStep(stepName);
        currentStep.find("span .indicator.failed").removeClass("invisible");
    }
}

export default ProgressWizard