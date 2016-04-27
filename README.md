# **Simple Vagrant Demoes**

This illustrates how to create simple Vagrant systems using datafile format of your choosing, e.g. INI, YAML, JSON, XML, or Hosts.

This is an exercise in automating Vagrant, specifically using ruby scripting.  It is also an exercise in crafting provisioning scripts in Bash (Bourne Again Shell).

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

Open MSYS2 application, run:

```bash
$ pacman --needed -Sy bash pacman pacman-mirrors msys2-runtime
$ # close and re-open msys2
$ pacman -Su
```

## **About this Project**

### **Data Format**

The data is a 4D data structure (hash of hash of list of hash) to spice things up.  Each section is divided into of configuration area: `hosts`, `defaults`, and `ports`.  Thus there may be redundancy.  

The provisioning scripts only care about `hosts` key, so they'll try to rip this out into arrays to use the data.  This is used to configure `hosts` and `ssh_config` for ssh and name resolution convenience.

### **Robust Code**

Robust code, this is not.  The sample code is just for illustrative purposes. Don't do this at home!

Things you would want to do if using professionally:
 * ***Don't trust that the file exist!*** check for it, or at least handle the exception, and print out *purdy* message for the user.
 * ***Don't trust data is clean!*** Example, two systems can be defaulted to be the primary, there can only be one.

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
  * [Nori](https://rubygems.org/gems/nori/versions/2.6.0) - XML to Hash Translator
  * [inifile](https://rubygems.org/gems/inifile) - INI to Hash
