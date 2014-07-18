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
    # parse control file
    # grab pkg name, flag if internal or not
    # list of dependencies
    fileob = {}
    return None


def main():
    pkgs = findcontrol()
    for pkgname in pkgs:
        pkg = parsecontrol(pkgname)
	print pkg
    # build 2 lists, internal and external packages
    exit(0)


if __name__ == '__main__':
    main()
