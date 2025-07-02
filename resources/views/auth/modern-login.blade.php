@extends('layouts/modern-login')

{{-- Page content --}}
@section('content')

<div class="modern-login-header">
    <h1 class="modern-login-title">{{ trans('auth/general.login_prompt') }}</h1>
    <p class="modern-login-subtitle">{{ trans('auth/general.welcome_back') ?? 'Welcome back! Please sign in to your account.' }}</p>
</div>

<form role="form" action="{{ url('/login') }}" method="POST" autocomplete="{{ (config('auth.login_autocomplete') === true) ? 'on' : 'off'  }}">
    <input type="hidden" name="_token" value="{{ csrf_token() }}" />
    
    <!-- Prevent autofill hack -->
    <input type="text" name="prevent_autofill" id="prevent_autofill" value="" style="display:none;" aria-hidden="true">
    <input type="password" name="password_fake" id="password_fake" value="" style="display:none;" aria-hidden="true">

    {{-- Google Login Button --}}
    @if (($snipeSettings->google_login=='1') && ($snipeSettings->google_client_id!='') && ($snipeSettings->google_client_secret!=''))
        <a href="{{ route('google.redirect') }}" class="modern-btn-google">
            <i class="fab fa-google"></i>
            {{ trans('auth/general.google_login') }}
        </a>
        <div class="modern-divider">
            <span>{{ strtoupper(trans('general.or')) }}</span>
        </div>
    @endif

    {{-- Login Note --}}
    @if ($snipeSettings->login_note)
        <div class="modern-alert modern-alert-info">
            {!! Helper::parseEscapedMarkedown($snipeSettings->login_note) !!}
        </div>
    @endif

    {{-- Notifications --}}
    @include('auth.modern-notifications')

    {{-- Regular Login Form --}}
    @if (!config('app.require_saml'))
        <fieldset name="login" aria-label="login">
            <legend style="display: none;">Login Form</legend>

            {{-- Username Field --}}
            <div class="modern-form-group has-icon{{ $errors->has('username') ? ' has-error' : '' }}">
                <label for="username">
                    {{ trans('admin/users/table.username') }}
                </label>
                <input 
                    class="modern-form-control" 
                    placeholder="{{ trans('admin/users/table.username') }}" 
                    name="username" 
                    type="text" 
                    id="username" 
                    autocomplete="{{ (config('auth.login_autocomplete') === true) ? 'on' : 'off' }}" 
                    autofocus
                    value="{{ old('username') }}"
                >
                <i class="fas fa-user modern-form-icon"></i>
                @if ($errors->has('username'))
                    <div class="modern-error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        {{ $errors->first('username') }}
                    </div>
                @endif
            </div>

            {{-- Password Field --}}
            <div class="modern-form-group has-icon{{ $errors->has('password') ? ' has-error' : '' }}">
                <label for="password">
                    {{ trans('admin/users/table.password') }}
                </label>
                <input 
                    class="modern-form-control" 
                    placeholder="{{ trans('admin/users/table.password') }}" 
                    name="password" 
                    type="password" 
                    id="password" 
                    autocomplete="{{ (config('auth.login_autocomplete') === true) ? 'on' : 'off' }}"
                >
                <i class="fas fa-lock modern-form-icon"></i>
                @if ($errors->has('password'))
                    <div class="modern-error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        {{ $errors->first('password') }}
                    </div>
                @endif
            </div>

            {{-- Remember Me Checkbox --}}
            <div class="modern-checkbox-wrapper">
                <label class="modern-checkbox">
                    <input name="remember" type="checkbox" value="1" id="remember">
                    <span class="modern-checkbox-custom"></span>
                </label>
                <label for="remember" class="modern-checkbox-label">
                    {{ trans('auth/general.remember_me') }}
                </label>
            </div>

            {{-- Login Button --}}
            <button class="modern-btn-primary" type="submit" id="submit">
                {{ trans('auth/general.login') }}
            </button>
        </fieldset>
    @endif

    {{-- SAML Login Link --}}
    @if (!config('app.require_saml') && $snipeSettings->saml_enabled)
        <div class="modern-divider">
            <span>{{ strtoupper(trans('general.or')) }}</span>
        </div>
        <a href="{{ route('saml.login') }}" class="modern-btn-google">
            <i class="fas fa-key"></i>
            {{ trans('auth/general.saml_login') }}
        </a>
    @endif

    {{-- SAML Only --}}
    @if (config('app.require_saml'))
        <a class="modern-btn-primary" href="{{ route('saml.login') }}">
            <i class="fas fa-key"></i>
            {{ trans('auth/general.saml_login') }}
        </a>
    @endif

    {{-- Forgot Password Link --}}
    @if ($snipeSettings->custom_forgot_pass_url)
        <div class="modern-forgot-password">
            <a href="{{ $snipeSettings->custom_forgot_pass_url }}" rel="noopener">
                {{ trans('auth/general.forgot_password') }}
            </a>
        </div>
    @elseif (!config('app.require_saml'))
        <div class="modern-forgot-password">
            <a href="{{ route('password.request') }}">
                {{ trans('auth/general.forgot_password') }}
            </a>
        </div>
    @endif

</form>

@stop
