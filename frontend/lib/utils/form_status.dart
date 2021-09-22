abstract class FormSubmissionState {
  const FormSubmissionState();
}

class InitialFormStatus extends FormSubmissionState {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionState {
  const FormSubmitting();
}

class SubmissionSuccess extends FormSubmissionState {
  const SubmissionSuccess();
}

class SubmissionFailure extends FormSubmissionState {
  const SubmissionFailure(this.exception);

  final Exception exception;
}
