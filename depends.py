#! /usr/bin/env python

import fnmatch
import os
import pydot

# if problems with parse_dot:
# pip uninstall pyparsing
# pip install -Iv https://pypi.python.org/packages/source/p/pyparsing/pyparsing-1.5.7.tar.gz#md5=9be0fcdcc595199c646ab317c1d9a709
# pip install pydot

def findcontrol():
    # taken from http://stackoverflow.com/questions/2186525/use-a-glob-to-find-files-recursively-in-python
    matches = []
    for root, dirnames, filenames in os.walk('pkgs/workbench'):
        for filename in fnmatch.filter(filenames, 'control'):
            matches.append(os.path.join(root, filename))
    return matches


def parsecontrol(path):
    # grab pkg name, flag if internal or not
    # list of dependencies
    fileob = {"name":"", "depends":[]}  
    for line in open(path, 'r'):
        if line.startswith("Package:"):
            fileob["name"] = line.replace("Package:","").strip()
            fileob["ourrepo"] = True
        if line.startswith("Depends:"):
            depline = line.replace("Depends:","").strip()
            fileob["depends"] = []
            for dependency in depline.split(","):
                 fileob["depends"].append(dependency.strip())
    return fileob


def generategraph(pkgs):
    graph = pydot.Dot(graph_type='graph')
    for pkg in pkgs:
        pkgname = pkg["name"]
        graph.add_node(pydot.Node(pkgname))
        for dependency in pkg["depends"]:
             graph.add_edge(pydot.Edge(pkgname,dependency))
    return graph


def main():
    pkgfiles = findcontrol()
    pkgs = []
    for pkgname in pkgfiles:
        pkg = parsecontrol(pkgname)
        if pkg is not None:
            pkgs.append(pkg)
    # build 2 lists, internal and external packages

    graph = generategraph(pkgs)
    graph.write_png("dependencies.png")
    print "Scanned %s folders, found %s packages" % (len(pkgfiles),len(pkgs))
    exit(0)


if __name__ == '__main__':
    main()
