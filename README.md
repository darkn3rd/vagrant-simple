# **Simple Vagrant Demoes**

This illustrates how to create simple Vagrant systems using datafile format of your choosing, e.g. INI, YAML, JSON, XML, or Hosts.

This is an exercise in automating Vagrant, specifically using ruby.  It is also an exercise in crafting provisioning scripts in Bash (or other language).

## **Robust Code**

Robust code, this is not.  The sample code is just for illustrative purposes. Don't do this at home.

Things you would want to do:
 * Don't trust file exist, check for it, or handle the exception, and print out purdy message for the user.
 * Don't trust data is clean, such as system designated as primary, there can only be one.

## Research

* Vagrant Multi-Machine Docs: https://www.vagrantup.com/docs/multi-machine/
* Bash
  * Bash Ini Parser - http://theoldschooldevops.com/2008/02/09/bash-ini-parser/
  * Parse Yaml Script - https://gist.github.com/pkuczynski/8665367
  * JSON.sh - https://github.com/dominictarr/JSON.sh
* Command Line Tools
  * jq - https://stedolan.github.io/jq/
  * xml2 - http://www.ofb.net/~egnor/xml2/
  * json2csv - https://github.com/jehiah/json2csv
  * xml2json - https://github.com/Inist-CNRS/node-xml2json-command
  * csvkit - http://csvkit.readthedocs.org/en/0.9.1/
  * yaml2json - https://www.npmjs.com/package/yamljs
  * json2yaml - https://www.npmjs.com/package/yamljs
  * shyaml - https://github.com/0k/shyaml
* Ruby Gems
  * [Nori](https://rubygems.org/gems/nori/versions/2.6.0) - XML to Hash Translator
  * [inifile](https://rubygems.org/gems/inifile) - INI to Hash

```bash
apt-get install -y jq xml2 node
```
