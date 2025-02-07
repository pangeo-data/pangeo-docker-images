#!/usr/bin/python
# Copyright 2022 CS GROUP - France, http://www.c-s.fr
# All rights reserved

import sys
import json

settings_file_path = sys.argv[1]
try:
    try:
        with open(settings_file_path) as settings_file:
            data = json.load(settings_file)
    except FileNotFoundError:
        print('ERROR: User settings file not found.. Creating new one')
        data = {}

    data['extensions.autoUpdate'] = False
    data['update.mode'] = "none"
    with open(settings_file_path, 'w+') as settings_file:
        json.dump(data, settings_file, indent=2)
    print('INFO: User settings file successfully overidden')

except:
    print('ERROR: Error during VSCode user settings file set up ...')