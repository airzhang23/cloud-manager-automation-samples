from bs4 import BeautifulSoup
import requests
import json

url = 'https://releases.hashicorp.com/terraform/index.html'
data = requests.get(url, allow_redirects=True, verify = False)
soup = BeautifulSoup(data.text,'html.parser')

inner_ul = soup.find('ul')
inner_items = [li.text.strip() for li in inner_ul.find_all('li')]
ver = inner_items[1].split('_')[1]
terraformUrl = 'https://releases.hashicorp.com/terraform/' + ver + '/terraform_' + ver + '_linux_amd64.zip'
r = requests.get(terraformUrl, stream=True, verify = False)
with open("terraform_" + ver + "_linux_amd64.zip", "wb") as code:
    code.write(r.content)
