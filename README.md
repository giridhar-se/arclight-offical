<<<<<<< HEAD
[![Gem Version](https://badge.fury.io/rb/arclight.svg)](https://badge.fury.io/rb/arclight)
[![npm version](https://badge.fury.io/js/arclight.svg)](https://badge.fury.io/js/arclight)
![Build Status](https://github.com/projectblacklight/arclight/workflows/CI/badge.svg)
[![All Contributors](https://img.shields.io/badge/all_contributors-17-orange.svg?style=flat-square)](CONTRIBUTORS.md)
[![Code Climate Test Coverage](https://codeclimate.com/github/projectblacklight/arclight/badges/coverage.svg)](https://codeclimate.com/github/projectblacklight/arclight/coverage)

# ArcLight

A Rails engine supporting discovery of archival materials, based on [Blacklight](https://projectblacklight.org/)


## Requirements

* [Ruby](https://www.ruby-lang.org/en/) 3.0.3 or later
* [Rails](http://rubyonrails.org) 7.1 or later
* Solr 8.1 or later

## Installation

[Installing ArcLight](https://github.com/projectblacklight/arclight/wiki/Creating,-installing,-and-running-your-ArcLight-application) is straightforward in a Rails environment.

Basically, add this line to your application's `Gemfile`:

```ruby
gem 'arclight'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install arclight
```

For further details, see our [Installing ArcLight](https://github.com/projectblacklight/arclight/wiki/Creating,-installing,-and-running-your-ArcLight-application) documentation.

## Usage

Arclight is a Ruby gem designed to work with archival data. It can be installed on a server or virtual server. Once running, finding aids in the form of archival collection data can be imported into Arclight through an indexing process. Institutional and repositories data can also be added to Arclight (Currently this requires a developer. Configuration pages will be added for this in future versions). Additional finding aids can be added at any time.

After data indexing, Arclight can to be used to search, browse, and display the repositories (sets of collections), collections, and components within collections. Globally available search allows filtering on several types of terms (Keyword, Name, Place, etc.). Once a search is begun, it can be further narrowed using facets on the left side of the search page. Selecting a search result goes directly to that results show or display page. Also global available are buttons for Repositories and Collections which can be used an any time.

Browsing allows you to view the Overview or Contents (when it exists) of a collection. The Overview tab displays top level metadata about the collection. The Contents tab displays an outline view of a next level of the collection. You can expand each level by selecting (clicking). Selecting a component in the Contents views goes to a component page which shows the metadata for it.

Some pages include an inline view tab to the right of an item which will expand the Contents further.

See the [ArcLight demo](https://arclight-demo.projectblacklight.org/) and [ArcLight MVP Wiki](https://github.com/projectblacklight/arclight/wiki) for usage.

See [Arclight Major Features](https://github.com/projectblacklight/arclight/wiki/Arclight-Major-Features) for a list of features.

### Traject indexing of EAD content
[Traject](https://github.com/traject/traject) is a high performance way of transforming documents for indexing into Solr and how ArcLight does indexing. An EAD2 can be indexed by doing the following:

```sh
bundle exec traject -u http://127.0.0.1:8983/solr/blacklight-core -i xml -c lib/arclight/traject/ead2_config.rb spec/fixtures/ead/sample/large-components-list.xml
```

Or

```sh
bundle exec rake arclight:seed
```

## Resources

* General
  * [ArcLight demo site](https://arclight-demo.projectblacklight.org/)
  * [ArcLight Github wiki](https://github.com/projectblacklight/arclight/wiki): developer/implementor documentation
  * [Blacklight wiki](https://github.com/projectblacklight/blacklight/wiki)
  * Use the [ArcLight Google Group](http://groups.google.com/d/forum/arclight-community) to contact us with questions
* ArcLight MVP:
  * [MVP sprint demo videos](https://www.youtube.com/playlist?list=PLMdUaIJ0G8QgbuDCUVvFhTSTO96N37lRA)

## Contributors

See the [CONTRIBUTORS](CONTRIBUTORS.md) file.

## Development

### Branches

* The `main` branch is for new development for the upcoming 2.0.0 release.
* The `1.x` series is on the [release-1.x](https://github.com/projectblacklight/arclight/tree/release-1.x) branch

### Start Solr

ArcLight requires Solr to be running.  For development you can start this using `solr_wrapper` or you may choose to use Docker. Start Solr using Docker by doing `docker compose up`.

### Run the test suite

Ensure Solr and Rails are _not_ running (ports 8983 and 3000 respectively), then:

```sh
$ bundle exec rake
```
If you find that the tests are failing when you run them on a Linux computer, you might need to install Google Chrome so the Selenium testing framework can run properly.

### Run a development server

```sh
$ bundle exec rake arclight:server
```

Then visit http://localhost:3000. It will also start a Solr instance on port 8983.

### Run a console

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Releasing

#### To release a new gem:

1. Update the version number in `lib/arclight/version.rb`
2. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, build the gem file (e.g., `gem build arclight.gemspec`) and push the `.gem` file to [rubygems.org](https://rubygems.org) (e.g., `gem push arclight-x.y.z.gem`).

#### To release the frontend sources:

When any of the javascript components or SASS sources in the gem are changed, this package should be published to NPM with the following steps:
1. [Install npm](https://www.npmjs.com/get-npm)
2. Bump the version number in `package.json`
3. run `npm run build && npm publish` to push the javascript package to https://npmjs.org/package/arclight

## Contributing

[Bug reports](https://github.com/projectblacklight/arclight/issues) and [pull requests](https://github.com/projectblacklight/arclight/pulls) are welcome on ArcLight -- see [CONTRIBUTING.md](https://github.com/projectblacklight/arclight/blob/main/CONTRIBUTING.md) for details.
## License

The gem is available as open source under the terms of the [Apache 2 License](https://opensource.org/licenses/Apache-2.0).

ArcLight also uses embedded SVG icons from the [FontAwesome](https://fontawesome.com) project. These icons are unmodified and licensed [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). All of these icons have the license and attribution embedded in them.
=======
cd to docker folder

import the xml files under project create my-ead/atom-export-ead/ ****.xml's

to Set correct permissions on solr directory:
sudo chown -R 8983:8983 ../solr/arclight/data
sudo chmod -R 755 ../solr/arclight/data

building app
docker compose build --no cache

to start containers
docker-compose up -d

to prepare db and load tables
docker compose exec app bundle exec rails db:schema:load
docker compose exec app bundle exec rails db:prepare
docker compose exec app bundle exec rails db:migrate

-> to index in to solr
docker compose exec app rake dul_arclight:index_dir DIR=/opt/app-root/finding-aid-data

now app is running on localhost:3000








<!-- # DUL ArcLight (Duke University Libraries)

Discovery & access application for archival material at Duke University Libraries. A front-end for archival finding aids / collection guides, built on the [ArcLight](https://github.com/projectblacklight/arclight) engine.

The application currently runs at [https://archives.lib.duke.edu](https://archives.lib.duke.edu).

## Requirements

* [Ruby](https://www.ruby-lang.org/en/) 2.7 or later
* [Rails](http://rubyonrails.org) 6.1 or later

## Getting Started

Please consult the **[DUL-ArcLight wiki](https://gitlab.oit.duke.edu/dul-its/dul-arclight/-/wikis/home)**
for full documentation. Here are a few common commands ...

You can index a set of sample Duke EAD files into Solr (takes a couple minutes):

    $ .docker/dev.sh exec app bundle exec rake dul_arclight:reindex_everything

Background processing jobs for indexing may be monitored using at:
http://localhost:3000/queues

To index a single finding aid:

    $ .docker/dev.sh exec app \
		bundle exec rake dul_arclight:index \
		FILE=./sample-ead/ead/rubenstein/rushbenjaminandjulia.xml \
		REPOSITORY_ID=rubenstein

Clear the current index:

	$ .docker/dev.sh exec app bundle exec rake arclight:destroy_index_docs

## OKD Notes

After the Helm chart is initially deployed, the Solr configuration must be manually
copied:

    $ oc rsync solr/arclight/conf/ solr-0:/var/solr/data/arclight/conf/

The web UI can then be used to scale down the Solr pods to 0 and back to 1.

The index can be populated by:

    $ oc exec POD -c app -- ./bin/rails dul_arclight:reindex_everything

Get the pod name with `oc get pods` or use the oc bash completion (if installed)
with prefix `app-`.

## Resources

* [ArcLight on GitHub](https://github.com/projectblacklight/arclight)
* [ArcLight project wiki](https://wiki.lyrasis.org/display/samvera/ArcLight) -->
>>>>>>> arclight-ks/master
