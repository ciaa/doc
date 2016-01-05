<h1>Readme</h1>

This is the Root directory of the CIAA Documentation Project. This project contains the Documentation of the CIAA Project.
During the development of new modules and not completed documentation may be found in the CIAA Project WebPage:
http://www.proyecto-ciaa.com.ar. Once the documentation becomes stable is added to this documentation repo.

<h2>Dependencies to build the documentation</h2>

This documentation is based on **DocBook** you will need the following packages in Linux to generate pdfs and htmls
documentation:

```
sudo apt-get install libxml2-utils
sudo apt-get install xsltproc
sudo apt-get install fop
```

NOTE: DocBook package itself is not needed, since is part of this repo.

<h2>How to build this documentation</h2>

Once you have the needed dependencies you can run the command:

```
make
```

to build all documents. You may also use the command ```make help``` to more details.
