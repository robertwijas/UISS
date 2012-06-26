# What is UISS?

UISS stands for UIKit Style Sheets.

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

**TODO**

# Install

* get the code
* add UISS.xcodeproj to your project
* (optional) add UISSResource.bundle to your target

## Configure UISS

### Local

The simplest way to start with UISS is to create `uiss.json` file and add it to your project's resources. To activate this file add this line:

```objc
    [UISS configureWithDefaultJSONFile];
```

This should be called before your views are displayed, the common place for that is your Application Delegate's _didFinishLaunching_ method.

### Remote

If you want to load your style from remote location to enable live updates, here's how to do that:

```objc
    UISS *uiss = [[UISS alloc] init];
    uiss.style.url = [NSURL URLWithString:@"http://your.awesome.domain/uiss.json"];
    [uiss load];
```

### Live updates

UISS can detect if your style changed and automatically update your interface. To enable this feature call this method:

```objc
    [uiss enableAutoReloadWithTimeInterval:3];
```

### Status bar

```objc
    uiss.statusWindowEnabled = YES;
```

UISS will take a small portion of the screen (usually taken by status bar) to show you what is going on behind the scenes.

### Console

Tapping on UISS status bar will present console view where:

* you can get info about errors in your style
* you can generate UIAppearance code for your style

# Sytax

## Converters

## Variables

## User Interface Idioms

