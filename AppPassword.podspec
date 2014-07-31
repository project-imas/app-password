Pod::Spec.new do |s|
    s.name          = 'AppPassword'
    s.version       = '1.0'
    s.license       = 'Apache-2.0'
  
    s.summary       = 'Custom iOS user authentication mechanism (password with security questions for self reset)'
    s.description   = %[
        The "iMAS App Password" framework provides a simple way to include passcode support into your application. It has the logic to enforce passcode strength, and can react to any passcode input. The framework contains two types of passcode controls, a simple passcode (numeric) and a complex passcode (a combination of numbers and characters). The framework utilizes the "iMAS Secure Foundation" framework in order to provide advanced security for both types of controls.
    ]
    s.homepage      = 'https://github.com/project-imas/app-password/'
    s.authors       = {
        'MITRE' => 'imas-proj-list@lists.mitre.org'
    }
  
    s.source        = {
        :git => 'https://github.com/project-imas/app-password.git',
        :tag => '1.0' 
    }

    s.requires_arc  = true

    s.platform      = :ios
    s.ios.deployment_target = '6.1'
    s.source_files  = 'AppPassword/*.{h,m}'
    s.exclude_files = 'AppPassword/main.m'

#   SecureFoundation podspec is not in the official Cocoapods spec repo, so remember to include it in your Podfile BEFORE you try to include AppPassword
    s.dependency 'SecureFoundation', '~> 1.0'
end
