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

    markCallFailed() {
        this._markStepFailed("make-call");
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

    markTriageFailedInactive() {
        this._markStepFailedInactive("triage");
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

    markAssignFailedInactive() {
        this._markStepFailedInactive("assign");
    }

    markCompleteCurrent() {
        this._markStepCurrent("complete")
    }

    markCompleteCurrentInactive() {
        this._markStepCurrentInactive("complete");
    }

    _findStep(stepName) {
        return this.steps.filter(`[data-step='${stepName}']`);
    }

    _markStepCurrent(stepName) {
        const currentStep = this._findStep(stepName);
        currentStep.addClass("current-step");
    }

    _markStepCurrentInactive(stepName) {
        const currentStep = this._findStep(stepName);
        currentStep.addClass("current-step inactive");
    }

    _markStepComplete(stepName) {
        const currentStep = this._findStep(stepName);
        currentStep.addClass("completed-step");
        currentStep.find("span.indicator.completed").removeClass("invisible")
    }

    _markStepFailed(stepName) {
        const currentStep = this._findStep(stepName);
        currentStep.find("span.indicator.failed").removeClass("invisible");
        currentStep.addClass("failed-step");
    }

    _markStepFailedInactive(stepName) {
        const currentStep = this._findStep(stepName);
        currentStep.find("span.indicator.failed").removeClass("invisible");
        currentStep.addClass("inactive");
    }
}

export default ProgressWizard