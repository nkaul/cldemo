#! /usr/bin/env python

import fnmatch
import os


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
    fileob = {}  
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


def main():
    pkgfiles = findcontrol()
    pkgs = []
    for pkgname in pkgfiles:
        pkg = parsecontrol(pkgname)
        if pkg is not None:
            pkgs.append(pkg)
    # build 2 lists, internal and external packages
    print "Scanned %s folders, found %s packages" % (len(pkgfiles),len(pkgs))
    exit(0)


if __name__ == '__main__':
    main()
