@if ($errors->any())
    <div class="modern-alert modern-alert-danger">
        <i class="fas fa-exclamation-triangle"></i>
        <strong>{{ trans('general.notification_error') }}:</strong>
        {{ trans('general.notification_error_hint') }}
    </div>
@endif

@if ($message = session()->get('status'))
    <div class="modern-alert modern-alert-info">
        <i class="fas fa-info-circle"></i>
        <strong>{{ trans('general.notification_info') ?? 'Info' }}:</strong>
        {{ $message }}
    </div>
@endif

@if ($message = session()->get('success'))
    <div class="modern-alert modern-alert-info" style="background-color: #d4edda; border-color: #a3d1a6; color: #155724;">
        <i class="fas fa-check-circle"></i>
        <strong>{{ trans('general.notification_success') }}:</strong>
        {{ $message }}
    </div>
@endif

@if ($message = session()->get('success-unescaped'))
    <div class="modern-alert modern-alert-info" style="background-color: #d4edda; border-color: #a3d1a6; color: #155724;">
        <i class="fas fa-check-circle"></i>
        <strong>{{ trans('general.notification_success') }}:</strong>
        {!! $message !!}
    </div>
@endif

@if ($message = session()->get('error'))
    <div class="modern-alert modern-alert-danger">
        <i class="fas fa-exclamation-triangle"></i>
        <strong>{{ trans('general.notification_error') }}:</strong>
        {{ $message }}
    </div>
@endif

@if ($message = session()->get('warning'))
    <div class="modern-alert modern-alert-info" style="background-color: #fff3cd; border-color: #fdb863; color: #856404;">
        <i class="fas fa-exclamation-triangle"></i>
        <strong>{{ trans('general.notification_warning') ?? 'Warning' }}:</strong>
        {{ $message }}
    </div>
@endif

@if ($message = session()->get('info'))
    <div class="modern-alert modern-alert-info">
        <i class="fas fa-info-circle"></i>
        <strong>{{ trans('general.notification_info') ?? 'Info' }}:</strong>
        {{ $message }}
    </div>
@endif
