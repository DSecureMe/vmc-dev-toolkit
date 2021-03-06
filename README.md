# vmc-dev-toolkit
VMC Developer Toolkit - **[VMC](https://github.com/DSecureMe/vmc)** (OWASP Vulnerability Management Center) is a platform designed to make vulnerability governance easier for any security specialists and SOC teams within their organisations. VMC is a great partner in any vulnerability management process, allowing automation and making your life easier. You can integrate VMC with vulnerability scanners and platforms like [TheHive](https://github.com/TheHive-Project/TheHive). Additionally, VMC takes care of asset management integrating with [Ralph](https://github.com/allegro/ralph), whole vulnerability reporting and dashboards ([Kibana](https://github.com/elastic/kibana)) for the clear overview. VMC allows you to focus on the most important vulnerability issues within your environment.

## First Steps
First, you need to download all dependent repositories with the command:
```
git submodule update --init --recursive
```

Then download all dependencies with the command:

```make prepare-dev```

## How to run tests
### Skip all tests with ELK:
```
make test
```

### Tests with ELK:
```
make up elastic=y
make test all=y
```

### Test module:
```
make test modules=vmc.assets
```

### Tox
```
make test tox=y
```

## How to build a dev vmc image
```
make build
```

## How to create migrations
```
make migrations
```
## How to run
```
make up
```

# More Details
## Documentation
We’ve made separate repository with guides and documentation available [here](https://github.com/DSecureMe/vmc-docs).
## Architecture
In simple words VMC requires data about detections from your scanner, information about assets and updates about CVE. Thanks to that VMC can live update your focus to the most emerging threats for your assets.
## License
Source code in this repository is covered by one of three licenses:
* the Apache License 2.0 https://www.apache.org/licenses/LICENSE-2.0
* the Apache License 2.0 compatible license
* the DSecure.me License.
The default license throughout the repository is Apache License 2.0 unless the header specifies another license.

# Try it
We encourage you to try our demo instance. You can get it from [here](https://github.com/DSecureMe/vmc-demo)
Instruction how to use it is in the demo [readme](https://github.com/DSecureMe/vmc-demo/blob/main/README.md) file


# Contributing
Please see our [Code of conduct](https://github.com/DSecureMe/vmc/blob/master/CODE_OF_CONDUCT.md). We welcome your contributions. Please feel free to fork the code, play with it, make some patches and send us pull requests via issues.

# Support
Please [open an issue on GitHub](https://github.com/DSecureMe/vmc/issues) if you'd like to report a bug or request a feature.

If you need to contact the project team, send an email to vmc-support@dsecure.me

# Website
https://dsecure.me