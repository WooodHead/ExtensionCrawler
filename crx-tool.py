#!/usr/bin/env python3
#
# Copyright (C) 2016 The University of Sheffield, UK
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

import argparse

# https://developer.chrome.com/extensions/crx
    
def verify_crxfile (verbose, filename):
    print("Not yet implemented: verify crxfile(", verbose,", ", filename, ")")

def extract_crxfile(verbose, force, filename):
    print("Not yet implemented: extract crxfile(",verbose,", ", force,", ", filename, ")")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("file", help="chrome extension archive (*.crx)")
    parser.add_argument("-c", "--check", help="verify format and signature of <file>",
                        action="store_true")
    parser.add_argument("-e", "--extract", help="extract <file>",
                        action="store_true")
    parser.add_argument("-f", "--force", help="apply action also to (potential) invalid files",
                        action="store_true")
    parser.add_argument("-v", "--verbose", help="increase verbosity",
                        action="store_true")
    args = parser.parse_args()
    
    if args.extract:
        retval = extract_crxfile(args.verbose, args.force, args.file)
    else: 
        retval = verify_crxfile(args.verbose, args.file)

    exit(retval)    
    
if __name__ == "__main__":
    main()
