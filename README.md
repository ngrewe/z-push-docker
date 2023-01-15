# Z-Push Container Image

This repository contains a Dockerfile and related Kubernetes configuration
examples for deploying the Z-Push ActiveSync implementation in a
containerised fashion.

## Supported features

The image, as it is built now, supports the following Z-Push features:

* IMAP backend
* Autodiscover
* memcached IPC implementation
* SQL state storage (including using PostgreSQL as a backend, which is a non-standard configuration)

## Configuration

Z-Push is usually configured via PHP `define()` calls in configuration files. The supplied container
image augments a couple of these `define()`s with the ability to load data from environment variables.
The name of the environment variables is identical to the name of the defined constant with `ZPUSH`
prepended. For a complete list of currently overridable settings cf. `kubernetes/z-push.env`.

## Kubernetes Example

The `kubernetes/` subdirectory contains a kustomization.yaml file illustrating how to deploy
a Z-Push installation into a Kubernetes cluster.

## License

Z-Push is (c) 2007 - 2016 Zarafa Deutschland GmbH and released under the AGPLv3 (cf. `LICENSE`). Files
taken from the Z-Push distribution retain their license headers indicating as much. All other code is
(c) 2023 Niels Grewe and licensed under the MIT license (cf. `LICENSE.MIT`).
