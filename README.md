# THIS GEM IS NOT MAINTENED ANYMORE

Some transporters make easy to fetch updated values (Colissimo), but most of them hide surcharge or display data in a way that is not easy to be parsed by computers (mixed GIF/HTML data). So instead of trying to keep on with inconsistent data, we switched back on manual updates.

Please get in touch with us if you want to take over.

# A transporters fuel surcharge fetcher

![Build workflow](https://github.com/levups/fuel_surcharge/workflows/build/badge.svg)

Retrieve current air and road rates applied to transporters shipping costs and
convert them to multipliers you can directly use in your app to calculate
precise shipping costs.

## Implemented transporters

  - [Colissimo](https://www.colissimo.entreprise.laposte.fr/fr/system/files/imagescontent/docs/indice_gazole.xml)
  - [Chronopost](https://www.chronopost.fr/fr/surcharge-carburant)
  - [TNT](https://www.tnt.com/express/fr_fr/site/home/comment-expedier/facturation/surcharges/baremes-et-historiques.html)

## Usage

Install the gem:

    $ gem install fuel_surcharge

Either run the executable to fetch and display the results:

    $ fuel_surcharge
    ---------------------------------------------------
    # Fuel surcharges for Colissimo on 12-2018
    # Fetched from https://www.colissimo.entreprise.laposte.fr/fr/system/files/imagescontent/docs/indice_gazole.xml

    AIR  = 3,58% / 1.0358
    ROAD = 2,24% / 1.0224

    ---------------------------------------------------
    # Fuel surcharges for Chronopost on Novembre 2018
    # Fetched from https://www.chronopost.fr/fr/surcharge-carburant

    AIR  = 20,15% / 1.2015
    ROAD = 14,80% / 1.1480

    ---------------------------------------------------
    # Fuel surcharges for Tnt on novembre 2018
    # Fetched from https://www.tnt.com/express/fr_fr/site/home/comment-expedier/facturation/surcharges/baremes-et-historiques.html

    AIR  = 18,50% / 1.1850
    ROAD = 12,10% / 1.1210

Or use it in your app:

    require 'fuel_surcharge'

    colissimo = FuelSurcharge::Colissimo.new
    colissimo.road_multiplier      # 0.10224e1
    colissimo.air_multiplier       # 0.10358e1

    chronopost = FuelSurcharge::Chronopost.new
    chronopost.road_multiplier     # 0.1148e1
    chronopost.air_multiplier      # 0.12015e1

    tnt = FuelSurcharge::TNT.new
    tnt.road_multiplier            # 0.1121e1
    tnt.air_multiplier             # 0.1185e1

## Releasing a new version of this gem

- bump version in `lib/fuel_surcharge/version.rb` and `.github_changelog_generator`
- run `git fetch --all --prune --tag` to ensure having latest tags
- update CHANGELOG.md file by running `github_changelog_generator`
- commit, push, merge PR for this release
- draft and validate a new release on https://github.com/levups/fuel_surcharge/releases/new
- GitHub action publishes new relase on rubygems automatically
