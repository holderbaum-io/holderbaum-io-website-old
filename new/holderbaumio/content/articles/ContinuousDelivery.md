---
title: "7 Lessons Learned about Continuous Delivery for Embedded Systems"
date: 2017-07-07
draft: true
---


Continuous Delivery has disrupted the way we build software: Every change goes
right to production, overall product quality often increases dramatically.
That’s surely not possible when you add Hardware to the mix. Or is it?
<!--more-->

This article will shine some light upon the concepts behind Continuous Delivery and how to apply them to Projects containing Embedded Software (using C or C++).
Embedded Software has become a ubiquitous part in most enterprises. Machine manufacturers start connecting their machines and devices into the cloud. Hardware manufacturers build more and more functionality utilizing the software layers. Consumer electronics gets more sophisticated, with more and more functionality based on software.

So let's start with some definitions:

## Embedded Software

What makes software embedded? Why do we face special challenges in the embedded software world beyond traditional software development challenges?

Embedded Software brings some unique challenges:

**Limited computing resources** because of various reasons. Embedded Devices are often limited by cost, physical size or power consumption which naturally leads to a reduced availability of computing power. Very often, a rich user experience has to be implemented on hardware that has the fraction of the power of a mobile phone or a home computer.

Besides that **code space is often limited as well** since smaller form factors or reduced silicon space is regularly met by reducing code memory and/or RAM size. This can be a tough challenge, if rich behaviour is needed in the product.

Since the devices are deployed physically, **updating can be a serious challenge**. A regular server application or a mobile phone app has distinct and well defined channels through which changes can be deployed. An Embedded Devices on the other hand needs a custom way to enable code changes later on. Implementing such an update channel in a safe and secure way can be a challenge in itself.

On Embedded Devices, **the behaviour is created through a mix of Hardware and Software**. Because of that, it can become quite complicated or even impracticable to update certain behaviour without a physical change to the system. This is a fundamental difference when compared to traditional software systems where literally everything is defined in software and thus changeable.

## Self Testing Code

<!-- TODO: find date -->
The term Self Testing Code has been coined around AXZY. It describes a perspective that successfully includes the notion of automated testing into the development phase of the actual code.

The concept basically demands, that a piece of software should provide means for the developers to make sure it does work as intended without manual effort. This means, that every project should have easily accessible automated tests that can be executed whenever a developer updates part of the code.

The term **Automated Testing** boils down to a few important concepts:

### Unit Tests

Unit Test are mainly considered to be the "developers" responsibility. They focus on testing technical components of the system to be build, most often in isolation. Their purpose can be summarized as:

> "Building the **system** correctly"

That means, the main focus of Unit Tests is the assurance, that the system behaves in a technically correct way (e.g. absence of Memory Leaks, or resilience against wrong input). The Unit Tests are most commonly written close to the actual development of the Unit under Test, meaning, immediately before or after implementing a chunk of code.

Having Unit Tests for your system does not only help in establishing a certain amount of confidence in your systems behaviour. It can also be of great help when encountering issues with your running software or hardware. It is a common practice to respond to a found bug by first extending a unit test to reproduce the bug or its root cause.

So the early creation of those Unit Tests provides a convenient debugging platform for the development and can serve as a regression test suite, if bugs are reproduced by writing tests.

### Acceptance Tests

Acceptance Tests on the other hand do not focus merely on technical aspects of the system. They focus on specific user-facing features and are most often written in a journey like fashion. One could say, that their main purpose is to ensure that you are:

> "Building the **correct** system"

So while Unit Tests focus on technical aspects, the Acceptance Tests only focus on features that are relevant to the final users of the system, be it installation technicians or buying customers.

To be able to write realistic Acceptance Tests, the team has to involve Domain Experts as early as possible. So for example, if your device has to be installed in factory machines by service technicians, their input is elementary to reflect a real user journey in the Acceptance Tests.

In most cases, those tests have to be executed against most parts of the system in combination. This does not necessarily have to include the final hardware, but it can be done with it. Very often, this is a difficult trade-off between execution speed of the tests and their relation to reality. The more parts are simulated (e.g. parts of hardware or services like a database) the faster those tests will execute. But they will also move away from the physical system that will be the final product. This can or can not be a risk, depending on many factors.

Cutting the line between these two extremes (**Fast Acceptance Tests** vs. **Realistic Acceptance Tests**) is often a tough decision, but it has to be made.

### Integration Tests

A third category of automated tests are the so called **Integration Tests**. Their purpose is neither focus on specific small aspects of components in the system nor establishing a correct user-facing behaviour. They are mainly used to test and verify the correct intercommunication between different parts of the system.

By having a set of automated Integration Tests, a team can greatly increase their confidence in the overall system that is build. This tests can also help with the previously mentioned decision making process about Acceptance Tests. If the integration with the surrounding hardware or other systems is thoroughly tested using Integration Tests, maybe the Acceptance Tests can be a bit more decoupled from certain slow and heavy parts of the product.

## Continuous Integration

Continuous Integration is a major technical cornerstones of Agile Methodologies. The word "Continuous" means, that every change on your code is tested and executed all the time. This is done by a CI server. This server has a constant eye on the repository of the project. Whenever a new commit appears, the automated test suite is executed. Every triggered build gets a assigned a so called **Build Number** which is ever increasing and thus always associated with exactly one build.

Such a concept brings great advantages to the overall project:

### Faster Feedback

The overall **feedback** when changing the software **increases in quality and frequency**. Whenever changes to the system are pushed, all tests are executed and every developer gets immediate feedback to the current state of development.

### Close Control over Build Environment

Because the system is **built and tested on the CI server**, a tighter control of the actual build environment can be enforced. Instead of going through complicated measurements to enforce certain versions and tools on the developer machines, the whole focus is put on the CI environment. Artifacts are only considered for release of they came from the CI server, never if they were constructed in a non-reproducible way on a developer machine.

### Deliverables in one Place

Since the CI Server builds every commit as soon as it encounters it, over time, a **continuous stream of deliverables is created**. Especially for bug triangulation, it can be very useful to be able to download the last 5 binaries to do some specific testing. The CI server thus very often works as an artifact repository for every build that was successful. And since every artifact has an associated build number, detailed information about the origin of a particular artifact can be easily retrieved (e.g. commit ID that it was based on or specifics about the used tool chain).

Of course, besides those advantages, introducing Continuous Integration to a team brings some major challenges that need to be overcome:

### Trunk Based Development

The concept of Trunk Based Development tries to reduce the amount of feature branches. Instead, most or all of the development should take place on the master branch simultaneously. Feature Branches can be substituted by abstractions and feature toggles. Adoption of this practice can by challenging. Nevertheless, experience shows over and over again, that in the mid term product quality and development speed increases to a higher and sustainable level.

### High Level of Test Automation

Testing and building of the product has to be 100% automated. This can sometimes be a technical challenge that would not have been tackled if the CI system weren't in place. Again, experience shows, that the short term increase of workload for automation quickly pays its return on invest: less documentation, fast feedback from CI, faster on boarding of new developers.

### Increased Short Term Complexity

All these aspects can be summarized as **Increased Complexity**. But this is no accidental complexity. Focusing on CI from the beginning makes issues transparent that otherwise would bubble up quite late in the project, where fixing would include major rework and significant delay. And the earlier challenges are faced, the more time and leeway exists to react accordingly.

## Continuous Delivery

Continuous Delivery combines the aspect of **Continuous Integration and Self Testing Code**. The testing, that is done on the CI system continuously, should be extensive enough, that no further manual testing is necessary. Every deliverable that is produced by the CI server can be released as is.

To achieve this goal, a lot of focus has to be put on the quality of the automated tests. They have to reflect the actual use cases of the system in such an comprehensive way, that all aspects are covered.

Experience shows, that teams which practice Continuous Delivery do release their deliverables more often, with greater confidence and with significantly higher quality. The process of releasing becomes less stressful, close to a non-event. And to achieve this goal, fully automated Self Testing Code is an irrevocable necessity.

## Continuous Deployment

If teams are successfully doing Continuous Delivery, the step towards Continuous Deployment is in reach. The major difference is, while Continuous Delivery just produces a theoretically production ready deliverable, Continuous Deployment also releases it every time.

So every commit triggers building, testing and releasing -- fully automated. In a server-based application, this would mean a deployment to production, for a smartphone app it would be the submission to the app store. But on projects that involve custom hardware, this can be an impractical step to take.

The main benefit over plain Continuous Delivery is the constant delivery of value to the customer and other product users. New functionality is available as early as possible and the team gets real feedback as fast as possible.

## Lesson 1: Cross Platform all the way

Embedded projects are facing change at the same rate as other software projects. Changes to the underlying hardware platform and architecture are a common theme and -- if handled improperly -- can delay the product by a significant amount of time.

When talking about test automation for embedded software, supporting multiple platforms is a prerequisite. The unit tests are usually written in C/C++ as well but executed on the developers machine. Focusing on a cross-platform architecture from the beginning brings many benefits:

### Enforced Business Logic encapsulation

If your software is compiled for more than one architecture (e.g. x86 for unit tests and ARM4 for the product), there is only one way to omit duplication of the business code: encapsulate it independent from the hardware. While this is in general a reasonable architectural advice, an upfront cross platform architecture enforces this.

### Unit Tests run on x86

Being able to run all unit tests on your developer machine in matter of seconds is a huge benefit. First of all it reduces the feedback loop size to a minimum. Changes to the code can be compiled and executed frequently. In addition, debugging becomes much easier for a locally running executable. The x86 compatibility also makes it much easier to run unit tests on the CI machine.

### Never worry about Hardware changes again

If your entire application is mostly hardware independent, porting it to a new platform or controller is very often just a task of creating a new compile target and adapting the hardware abstraction layer. This reduces the overhead of hardware changes significantly.

## Lesson 2: Unit Tests are Great for Code Quality

If unit tests are running on the x86 architecture, many tools can be used to scrutinize the code with Dynamic Analysis. Many advanced unit testing frameworks like e.g. [CppUTest](https://cpputest.github.io/) provide memory leak detection. This makes it possible to write domain code that is free of any memory leaks.

In addition, experience shows, that unit tests often help with cleaning up and refactoring production code.

**TODO: more to say here?**

## Lesson 3: Versioning is Hard

When the CI server continuously builds your software, special requirements emerge towards versioning. A typical scheme is the following: as with traditional software projects, somewhere inside the repository is a version defined, probably after semantic versioning:

```
[MAJOR].[MINOR].[BUILD]
```

Now whenever the CI builds and saves an artefact, it concatenates the build number to the defined version. This would lead to a continuous list of versions like in the following example:

```
0.1.12-build123
0.1.12-build124
0.1.12-build128
...
```

This is a common pattern found in many projects that are using CD. When you are releasing a piece of embedded software into an existing ecosystem, things can become trickier. It is not unusual, that hardware oriented companies have severe restrictions on established versioning schemes due to existing protocols between components.
Since those protocols are baked into the existing infrastructure, it is most often not possible to change the version scheme. The only way to overcome that challenge is to adapt your releasing scheme.

What often works is a separated versioning scheme. The deliverable has a main version that is maintained in the repository and strictly adheres to the companies standard. In addition to that, the build number is stored in the binary as well, but can be retrieved through different means, e.g. an additional protocol message or through an existing service channel.

This enables seamless integration into the company and at the same time, the important build number can be retrieved to audit where the binary came from.

## Lesson 4: Integration Tests with Interfaces

To reach the level of confidence about a releasable artifact, correct interaction with outside components has to be ensured. Most embedded systems do have some sort of communication with other systems, e.g. RS232, SPI, GSM, WiFi or CAN.

A thorough hardware based integration test should include all those physical interfaces. For most protocols, USB adapters exist that can work as a bridge. So the testing computer can physically emulate all necessary protocols and interact with the hardware under test through all channels.

This get's even more important if you are relying on third part drivers for certain protocols. Manually testing those is tedious and error prone. By having such a test setup run continuously, confidence in the interoperability of the constructed system increases vastly.

## Lesson 5: Test for expected Runtime

An often underestimated issue is the behaviour of the system over longer periods. Unit and integration tests as well as general interaction during development normally just runs the system for a few seconds or minutes before powering it down or restarting it. This can hide long term issues like task deadlocks or memory fragmentation.

It works pretty well to have a second hardware setup connected to the CI that runs the latests artifact for several hours and inspects it healthiness (e.g. memory consumption/fragmentation or response timings). This can go a long way towards gaining insights into the runtime behaviour of the system. Especially linearly increasing memory fragmentation or response times can be a disaster waiting to happen.

## Lesson 6: Downloadable releases are awesome

Beside developing and testing your product, chances are good that some part of your day consists of supporting people (e.g. technicians, testers or potential users) to flash and run your firmware. We could observe a significant reduction of time spent helping people testing the latest releases because of the CI server.

Since the CI server can be a platform to download the latest release candidates -- neatly labeled with version and build number -- people can easily reach out to it themselves:

```
firmware-v1.3.4-build1549.elf
```

Additionally, since all artifacts ideally contain version and build number in the file name, it becomes less likely that those files will lead to confused people inquiring your team about the origin of an

> "ominous `firmware.elf` file I found in my mail box several weeks ago".

## Lesson 7: Involve all Stakeholders upfront

Early Stakeholder involvement is not a new mantra. It surely is one of the cornerstones of agile methodologies.
Late changes in key requirements of a well written piece of software is in most cases no dramatic event. Automated tests and a high standard in code quality can absorb most of the sometimes quite drastic impact.

When physical hardware is involved on the other hand, the situation can be quite differently. There is a huge amount of people around an embedded system that will be affected directly or indirectly by design decisions. This goes from engineers that are involved in the commissioning of the final product over marketing personnel that has to demonstrate key features to potential clients to customers that have to use the end product. Those are just three example of a possibly vast crowd of people that are involved in bringing the product to life.

All of those can bring valid requirements into discussion that will most probably lead to breaking changes in the hardware or fundamental firmware rewriting -- unless they are part of the development from the first day.

So, get all hands on the table -- at least one person of each involved department -- into your bi-weekly product reviews.

**TODO: Probably state explicitely that ideally, practicioners and theorists should be involved.**

## Conclusions

...
