# What is UISS?

UISS is an iOS library that provides you with a convenient way to define the style of your application.  
UISS is built on top of UIKit UIAppearance proxies.

# What UISS can do for you?

UISS has the power to:

* replace unreadable UIAppearance code with a simple JSON dictionary,
* provide a way to change application style without the need to rebuild your code, without the need to restart your app, even without the need to reload your views - yep, this is *the sexy* feature of UISS.

# Design goal

UISS do not enforce any dependencies on your app. You can generate Objective-C code for your UISS style so you do not even have to link with UISS library in your production build.

# Yeah, yeah, nice ideas, but how does it really look like?

Assuming you're familiar with UIAppearance proxy you probably wrote a piece of code similar to this one:

```objc
    [[UITabBar appearance] setTintColor:[UIColor darkGrayColor]]
```

in UISS it looks like this:

```json
    {
        "UITabBar": {
            "tintColor": "darkGray",
        }
    }
```

no big difference here, so lets look at more complex example:

# Install

* get the code
* add UISS.xcodeproj to your project
* (optional) add UISSResource.bundle to your target

## Configure UISS

# Remote style and live updates

# Sytax sugar

## Converters

## Variables

## User Interface Idioms

# Code Generation

# UISS console and status bar

