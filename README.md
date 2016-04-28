# **Simple Vagrant Demoes**

by Joaquin Menchaca

This illustrates how to create simple Vagrant systems using data file format of your choosing, e.g. INI, YAML, JSON, XML, or Hosts.

This is an exercise in automating Vagrant, specifically using ruby scripting.  It is also an exercise in crafting provisioning scripts in Bash (Bourne Again Shell).

## **Examples**

- Static Configuration
    - [Single Machine](singlemachine/README.md)  
    - [Multi-Machine](multimachine/README.md)
- Dynamic Multi-Machine
    - Data-structure in Memory
       - [Using Ruby Hash](multimachine-mem/README.md)
  - Data-structure from File
       - [Hosts configuration file](multimachine-hosts/README.md)
       - [INI configuration file](multimachine-ini/README.md)
       - [CSV tables](multimachine-csv/README.md)
       - [SQL tables](multimachine-sql/README.md)
       - [JSON tree](multimachine-json/README.md)
       - [YAML tree](multimachine-yaml/README.md)
       - [XML tree](multimachine-xml/README.md)

## **Requirements**

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) - virtualization system
* [Vagrant](http://vagrantup.com/) - virtualization and provisioning automation tool

For Windows, highly recommend, [MSYS2](https://msys2.github.io/) as it gives you to `bash` shell and access to tools like `git`, `ssh`, `curl`, and `rsync`.  This is optional.

### **OS X**

Install [Homebrew](http://brew.sh/), [Cask](https://caskroom.github.io/), and [Brew Bundle](https://github.com/Homebrew/homebrew-bundle), then get other requirements by running:

```bash
$ brew bundle
$ vagrant plugin install sqlite3
$ vagrant plugin install inifile
```

### **Windows**

Install [Chocolately](chocolately) using command shell (`cmd.exe`) as Administrator, then run

```batch
C:\> choco install chocolately.config
C:\> vagrant plugin install sqlite3
C:\> vagrant plugin install inifile
```

If using MSYS2, open MSYS2 application, and run:

```bash
$ pacman --needed -Sy bash pacman pacman-mirrors msys2-runtime
```

Close and restart MSYS2 and run:

```bash
$ pacman -Su
```

## **About this Project**

### **Data Format**

The data is a 4D data structure (hash of hash of list of hash) to spice things up.  Each section is divided into of configuration area: `hosts`, `defaults`, and `ports`.  Thus there may be redundancy.  

The provisioning scripts only care about `hosts` key, so they'll try to rip this out into arrays to use the data.  This is used to configure `hosts` and `ssh_config` for ssh and name resolution convenience.

### **Robust Code**

Robust code, this is not.  The sample code is just for illustrative purposes. Don't do this at home!

Things you would want to do if using professionally:
    - ***Don't trust that the file exist!*** check for it, or at least handle the exception, and print out *purdy* message for the user.
    - ***Don't trust data is clean!*** Example, two systems can be defaulted to be the primary, there can only be one.

### **Final Notes**

### **Research**

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
    * [nori](https://rubygems.org/gems/nori/versions/2.6.0) - XML to ruby  hash ruby gem
    * [inifile](https://rubygems.org/gems/inifile) - ini to ruby hahs ruby gem
    * [sqlite3](https://rubygems.org/gems/sqlite3) - sqlite3 ruby gem

## **License**

The content of this project itself is licensed under the [Creative Commons Attribution 3.0 license](http://creativecommons.org/licenses/by/3.0/us/deed.en_US), and the underlying source code is licensed under the [MIT license](http://opensource.org/licenses/mit-license.php).
