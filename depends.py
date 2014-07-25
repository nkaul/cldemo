#! /usr/bin/env python

import argparse
import fnmatch
import os
import pydot

# if problems with parse_dot:
# pip uninstall pyparsing
# pip install -Iv https://pypi.python.org/packages/source/p/pyparsing/pyparsing-1.5.7.tar.gz#md5=9be0fcdcc595199c646ab317c1d9a709
# pip install pydot

def findcontrol(path):
    # taken from http://stackoverflow.com/questions/2186525/use-a-glob-to-find-files-recursively-in-python
    matches = []
    for root, dirnames, filenames in os.walk('%s' % (path)):
        for filename in fnmatch.filter(filenames, 'control'):
            matches.append(os.path.join(root, filename))
    return matches


def parsecontrol(path):
    # grab pkg name, flag if internal or not
    # list of dependencies
    fileob = {"name":'', "depends":[], "userdemo":False}  
    for line in open(path, 'r'):
        if line.startswith("Package:"):
            name = line.replace("Package:","").strip()
            fileob["name"] = name
            fileob["ourrepo"] = True
            if "-1s-" in name or "-2s-" in name or "-2s2l-" in name or "2lt22s" in name:
                fileob["userdemo"] = True
        if line.startswith("Depends:"):
            depline = line.replace("Depends:","").strip()
            fileob["depends"] = []
            for dependency in depline.split(","):
                 fileob["depends"].append(dependency.strip())
    return fileob


def generategraph(pkgs,extpkgs):
    graph = pydot.Dot(graph_type='digraph')
    # external packages
    for extpkg in extpkgs:
        graph.add_node(pydot.Node(extpkg, style="filled", fillcolor="red"))
    # our packages
    for pkg in pkgs:
        pkgname = pkg["name"]
        fillcolor="white"
        if pkg["userdemo"]:
            fillcolor = "yellow"
        graph.add_node(pydot.Node(pkgname, style="filled", fillcolor=fillcolor))
        for dependency in pkg["depends"]:
             graph.add_edge(pydot.Edge(pkgname,dependency))
    return graph


def main():

    # cmd opts
    parser = argparse.ArgumentParser(description='cldemo dependency mapper')
    parser.add_argument('-p', help='path',action='store',dest='path',required=True)
    parser.add_argument('-o', help='outputfile',action='store',dest='output',required=True)
    parser.add_argument('-t', help='type',action='store',dest='type',required=True, choices=['png'])
    parser.add_argument('-d', help='dot output',action='store',dest='dot',required=False)
    args = parser.parse_args()


    # loop through control files and parse contents
    pkgfiles = findcontrol(args.path)
    ourpkgs = []
    extpkgs = []
    for pkgname in pkgfiles:
        pkg = parsecontrol(pkgname)
        if pkg is not None:
            ourpkgs.append(pkg)
        # look for external dependencies
        for dependency in pkg["depends"]:
            if dependency.startswith("cldemo") is False:
                if dependency not in extpkgs:
                    extpkgs.append(dependency)

    graph = generategraph(ourpkgs,extpkgs)
    graph.write_png(args.output)
    if args.dot is not None:
        graph.write(args.dot)

   # summary
    print "Scanned %s folders, %s packages, %s external depends" % (len(pkgfiles),len(ourpkgs),len(extpkgs))
    
    exit(0)


if __name__ == '__main__':
    main()
