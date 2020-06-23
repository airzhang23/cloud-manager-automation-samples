from bs4 import BeautifulSoup
import requests
import json
import getopt
import sys

url = 'https://releases.hashicorp.com/terraform/index.html'
data = requests.get(url, allow_redirects=True, verify = False)
soup = BeautifulSoup(data.text,'html.parser')

def usage():
    print """Command line usage:

    -h, --help        This help screen
    -t, --tf-version  tf version to use. if not set latest tf version will be downloaded
    """

ver = None

# Script arguments and settings
try:
    opts, args = getopt.getopt(sys.argv[1:], "h:t:", ["--help", "--tf-version"])
except getopt.GetoptError as err:
    # print help information and exit:
    print str(err) # will print something like "option -a not recognized"
    usage()
    sys.exit(2)

for o, a in opts:
    if o in ("-h", "--help"):
        usage()
        sys.exit()
    elif o in ("-t", "--tf-version"):
        ver = a
    else:
        assert False, "unhandled option"

if (ver == None):
  inner_ul = soup.find('ul')
  inner_items = [li.text.strip() for li in inner_ul.find_all('li')]
  ver = inner_items[1].split('_')[1]

terraformUrl = 'https://releases.hashicorp.com/terraform/' + ver + '/terraform_' + ver + '_linux_amd64.zip'
print terraformUrl
r = requests.get(terraformUrl, stream=True, verify = False)
with open("terraform_" + ver + "_linux_amd64.zip", "wb") as code:
    code.write(r.content)
