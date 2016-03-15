# qdr

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with qdr](#setup)
    * [What qdr affects](#what-qdr-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with qdr](#beginning-with-qdr)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages the QPID Dispatch Router (qdr) found at:

     http://qpid.apache.org/components/dispatch-router/

The dispatch router provides flexible and scalable interconnect between any AMQP 1.0 endpoints, whether they be clients, brokers or other AMQP-enabled services

Support is intended for Red Hat and Ubuntu OS family deployed with Pupppet V4.x

## Module Description

This module sets up the installations, configuration and management of the QPID Dispatch
Router (qdr) class and has a number of providers that correpsond the router configuration
entities such as listeners and connectors.

This module will facilitate the deployment of a full/partial mesh topology of QPID Dispatch
Routers serving as the messaging interconnect for a site.


## Setup

### What qdr affects

* repository files
* packages
* configuration files
* service
* configuration entities 

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with qdr

    include '::qdr'

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
