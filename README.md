# **Simple Vagrant Demoes**

by Joaquin Menchaca, April 2016

This exercise that demonstrates [Vagrant](https://www.vagrantup.com/) configuration scenarios with a global configuration file.  As a bonus, an [Ansible](https://www.ansible.com/) dynamic inventory script that sources the same configuration file is provided.

This demonstrates how to parse a configuration file (in **INI**, **YAML**, **JSON**, **XML**, **CSV**, **SQL**, or **hosts** file formats) in [ruby](https://www.ruby-lang.org/en/), and [bash](https://www.gnu.org/software/bash/). amd [python](https://www.python.org/) languages.

## **Example Scenarios**

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
* [Ansible](https://www.ansible.com/) (optional) - change configuration tool that can execute commands on vagrant virtual systems.
   * [Python](https://www.python.org/) - language required by Ansible

For Windows, highly recommend, [MSYS2](https://msys2.github.io/) as it gives you to `bash` shell and access to tools like `git`, `ssh`, `curl`, and `rsync`.  This is optional.

Note that [Ansible](https://www.ansible.com/) is not officially supported on Windows for a workstation (or system used to configure other systems).

### **OS X**

Install [Homebrew](http://brew.sh/), [Cask](https://caskroom.github.io/), and [Brew Bundle](https://github.com/Homebrew/homebrew-bundle), then get other requirements by running:

```bash
$ ./install_macosx.sh
```

### **Windows**

Install [Chocolately](chocolately) using command shell (`cmd.exe`) as Administrator, then run

```batch
C:\> choco install chocolately.config
C:\> vagrant plugin install sqlite3
C:\> vagrant plugin install inifile
```

## **About this Project**

### **Data Format**

The data is a 4D data structure (*hash of hash of list of hash*) to spice things up.  Each section is divided into of configuration area: `hosts`, `defaults`, and `ports`.  Thus there may be redundancy.  

The provisioning and inventory scripts only care about `hosts` key, so they'll try to rip this out into arrays to use the data.  This is used to configure `hosts` and `ssh_config` for ssh and name resolution convenience.  For the inventory,this is used to create a `JSON` file that can be used with `ansible` or `ansible-playbook` commands.

### **Organization**

This is what the base file layout looks like, using YAML as an example:

```bash
.
├── multimachine-yaml
│   ├── README.md
│   ├── Vagrantfile        # main ansible configuration
│   ├── config
│   │   ├── global.yaml    # global configuration
│   │   └── inventory.py   # ansinble inventory script, must be next to config
│   └── scripts
│       ├── baselib.src    # local copy of baselib.sh
│       ├── client.sh      # provisioning script
│       ├── master.sh      # provisioning script
│       ├── setup-base.sh  # base provisioning script for ssh_config and hosts
│       ├── slave.sh       # provisioning script
│       ├── slave1.sh -> slave.sh # symlink to common provisioning script
│       └── slave2.sh -> slave.sh # symlink to common provisioning script
└── scriptlib
    ├── baselib.sh         # main shell provisioning library
    ├── common.vagrantfile # common base vagrantfile that uses settings hash
    └── yaml.rb            # creates settings hash from ruby
```

## **Final Notes**

### **MSYS2**

[MSYS2](https://msys2.github.io/) is a light minimalist bash environment for Windows, similar to [MSYS](http://www.mingw.org/wiki/msys) that comes with [MinGW](http://www.mingw.org/) (Minimalist GNU for Windows
) and [Git-Bash](https://git-for-windows.github.io/) tools, except that it is 64-bit.  If you use advanced features like rsync, then you'll need a 64-bit rsync solution.

After installing [MSYS2](https://msys2.github.io/), e.g. `choco install msys2`, run:

```bash
$ pacman --needed -Sy bash pacman pacman-mirrors msys2-runtime
```

Close and restart MSYS2 and run:

```bash
$ pacman -Su
$ # other tools (optional)
$ pacman -S rsync
$ pacman -S git
$ pacman -S curl
```

### **Research Links**

These are some topics I came across while researching Vagrant, Ruby libraries and shell command-line tools and scripts:

* Vagrant
    * Multi-Machine Docs: https://www.vagrantup.com/docs/multi-machine/
    * Vagrant 1.5 Plugin Improvements: https://www.hashicorp.com/blog/vagrant-1-5-plugin-improvements.html#toc_1
    * Vagrant Development Basics: https://www.vagrantup.com/docs/plugins/development-basics.html
    * Vagrant Packaging: https://www.vagrantup.com/docs/plugins/packaging.html
* Bash
    * Bash Ini Parser - http://theoldschooldevops.com/2008/02/09/bash-ini-parser/
    * Parse Yaml Script - https://gist.github.com/pkuczynski/8665367
    * JSON.sh - https://github.com/dominictarr/JSON.sh
* Command Line Tools
    * jq (JSON Query)- https://stedolan.github.io/jq/
    * xml2 - http://www.ofb.net/~egnor/xml2/
    * json2csv - https://github.com/jehiah/json2csv
    * xml2json - https://github.com/Inist-CNRS/node-xml2json-command
    * csvkit - http://csvkit.readthedocs.org/en/0.9.1/
    * yaml2json - https://www.npmjs.com/package/yamljs
    * json2yaml - https://www.npmjs.com/package/yamljs
    * shyaml - https://github.com/0k/shyaml
* Ruby Gems
    * [nori](https://rubygems.org/gems/nori/versions/2.6.0) - XML to ruby  hash ruby gem
    * [inifile](https://rubygems.org/gems/inifile) - ini to ruby hash ruby gem
    * [sqlite3](https://rubygems.org/gems/sqlite3) - sqlite3 ruby gem
* Python Packages
    * [simplejson](https://pypi.python.org/pypi/simplejson/) - SimpleJSON python module
    * [pyaml](https://pypi.python.org/pypi/pyaml/) - PyYAML
    * [configparser](https://pypi.python.org/pypi/configparser) - ConfigParser for INI files
* Tutorials/References
    * Python
       * [SQLite Python Tutorial](http://zetcode.com/db/sqlitepythontutorial/)
       * [Python Database API Specification v2.0](https://www.python.org/dev/peps/pep-0249/#cursor-methods)
       * [CSV File Reading and Writing](https://docs.python.org/2/library/csv.html)
       * The Hitchhiker's Guide to Python
          * [XML parsing](http://docs.python-guide.org/en/latest/scenarios/xml/)
          * [Parsing JSON](http://docs.python-guide.org/en/latest/scenarios/json/)


## **License**

The content of this project itself is licensed under the [Creative Commons Attribution 3.0 license](http://creativecommons.org/licenses/by/3.0/us/deed.en_US), and the underlying source code is licensed under the [MIT license](http://opensource.org/licenses/mit-license.php).
