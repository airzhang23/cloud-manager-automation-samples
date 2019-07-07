import configparser
import os.path
import sys

sys.argv[1:]
cred_file_path='/root/.aws/credentials'

def write_ini_section(cred_file_path,aws_access,aws_secret):
    config = configparser.ConfigParser()
    config.read(cred_file_path)
    if config.has_section('terraform'):
        config.set('terraform','aws_access_key_id'    ,aws_access)
        config.set('terraform','aws_secret_access_key',aws_secret)
        with open(cred_file_path, 'wb') as configfile:
            config.write(configfile)
    else:
        config['terraform'] = {'aws_access_key_id'       : aws_access,
                               'aws_secret_access_key'   : aws_secret}           
        with open(cred_file_path, 'wb') as configfile:
            config.write(configfile)    

def remove_ini_section(cred_file_path):
    config_test = configparser.ConfigParser()
    config_test.read(cred_file_path)    
    if config_test.has_section('terraform'):
        config = configparser.ConfigParser()
        with open(cred_file_path, 'r+') as s:
            config.readfp(s)  
            config.remove_section('terraform')
            s.seek(0)  
            config.write(s)
            s.truncate()    

if not os.path.isfile(cred_file_path):
    print("file doesn't exit %s" %(cred_file_path))
    exit(1)

action=sys.argv[1]
if action == 'add':
    aws_access=sys.argv[2]
    aws_secret=sys.argv[3]
    write_ini_section(cred_file_path,aws_access,aws_secret)
elif action == 'remove':    
    remove_ini_section(cred_file_path)
else:
    print('Filed! Allowed actions are: "add" or "remove"')
    exit(1)