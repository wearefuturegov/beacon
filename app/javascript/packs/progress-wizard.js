class ProgressWizard {
    constructor() {
        this.steps = $(".progress-wizard li");
    }

    markCallCurrent() {
        this._markStepCurrent("make-call");
    }

    markCallComplete() {
        this._markStepComplete("make-call");
    }

    markTriageCurrent() {
        this._markStepCurrent("triage");
    }

    markTriageComplete() {
        this._markStepComplete("triage");
    }

    markTriageFailed() {
        this._markStepFailed("triage");
    }

    markAssignCurrent() {
        this._markStepCurrent("assign");
    }

    markAssignComplete() {
        this._markStepComplete("assign");
    }

    markAssignFailed() {
        this._markStepFailed("assign");
    }

    markCompleteCurrent() {
        this._markStepCurrent("complete")
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
        currentStep.addClass("completed-step");
        currentStep.find("span.indicator.completed").removeClass("invisible")
    }

    _markStepFailed(stepName) {
        const currentStep = this._findStep(stepName);
        currentStep.find("span.indicator.failed").removeClass("invisible");
    }
}

export default ProgressWizard