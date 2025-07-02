<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ ($snipeSettings) && ($snipeSettings->site_name) ? $snipeSettings->site_name : 'Snipe-IT' }} - Login</title>

    <link rel="shortcut icon" type="image/ico" href="{{ ($snipeSettings) && ($snipeSettings->favicon!='') ?  Storage::disk('public')->url(e($snipeSettings->favicon)) : config('app.url').'/favicon.ico' }}">
    
    {{-- Base stylesheets --}}
    <link rel="stylesheet" href="{{ url(mix('css/dist/all.css')) }}">
    
    {{-- Modern login styles --}}
    <link rel="stylesheet" href="{{ asset('css/modern-login.css') }}">
    
    {{-- Font Awesome for icons --}}
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <script nonce="{{ csrf_token() }}">
        window.snipeit = {
            settings: {
                "per_page": 50
            }
        };
    </script>

    @if (($snipeSettings) && ($snipeSettings->header_color))
        <style>
        :root {
            --primary-color: {{ $snipeSettings->header_color }};
        }
        .modern-btn-primary {
            background: linear-gradient(135deg, {{ $snipeSettings->header_color }} 0%, {{ $snipeSettings->header_color }}cc 100%);
        }
        .modern-form-control:focus {
            border-color: {{ $snipeSettings->header_color }};
        }
        .modern-checkbox input[type="checkbox"]:checked + .modern-checkbox-custom {
            background-color: {{ $snipeSettings->header_color }};
            border-color: {{ $snipeSettings->header_color }};
        }
        .modern-forgot-password a {
            color: {{ $snipeSettings->header_color }};
        }
        .modern-privacy-link a:hover {
            color: {{ $snipeSettings->header_color }};
        }
        </style>
    @endif

    @if (($snipeSettings) && ($snipeSettings->custom_css))
        <style>
            {!! $snipeSettings->show_custom_css() !!}
        </style>
    @endif
</head>

<body class="modern-login-page">
    <div class="modern-login-container">
        @if (($snipeSettings) && ($snipeSettings->logo!=''))
            <div class="modern-login-header">
                <img class="modern-login-logo" src="{{ Storage::disk('public')->url('').e($snipeSettings->logo) }}" alt="{{ $snipeSettings->site_name }}">
            </div>
        @endif

        <!-- Content -->
        @yield('content')

        @if (($snipeSettings) && ($snipeSettings->privacy_policy_link!=''))
            <div class="modern-privacy-link">
                <a target="_blank" rel="noopener" href="{{ $snipeSettings->privacy_policy_link }}">
                    {{ trans('admin/settings/general.privacy_policy') }}
                </a>
            </div>
        @endif
    </div>

    {{-- Javascript files --}}
    <script src="{{ url(mix('js/dist/all.js')) }}" nonce="{{ csrf_token() }}"></script>

    {{-- Modern login JavaScript --}}
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Add loading state to login button
            const loginForm = document.querySelector('form[action*="/login"]');
            const loginButton = document.querySelector('.modern-btn-primary');
            
            if (loginForm && loginButton) {
                loginForm.addEventListener('submit', function(e) {
                    loginButton.classList.add('loading');
                    loginButton.disabled = true;
                });
            }

            // Enhanced focus effects
            const formControls = document.querySelectorAll('.modern-form-control');
            formControls.forEach(control => {
                control.addEventListener('focus', function() {
                    this.parentElement.classList.add('focused');
                });
                
                control.addEventListener('blur', function() {
                    this.parentElement.classList.remove('focused');
                });
            });

            // Auto-hide alerts after 5 seconds
            const alerts = document.querySelectorAll('.modern-alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => {
                        alert.remove();
                    }, 300);
                }, 5000);
            });
        });
    </script>

    @stack('js')
</body>

</html>
