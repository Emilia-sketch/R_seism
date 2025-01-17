from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from bs4 import BeautifulSoup
import pandas as pd
import time
import math
import re

url = 'http://seisnano.iag.usp.br:8888#state_of_health@bl.aqdb-taurus_2569'
headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 \
           (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36'}

#Selenium
options = webdriver.ChromeOptions()
options.add_argument('--headless')
driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=options)

driver.get(url)
time.sleep(5) # espera carregar a página
soup = BeautifulSoup(driver.page_source, features="html.parser") # leu a página carregada

dt = soup.find('tbody', class_ = re.compile("gwt-Label")).get_text().strip()

#td class="nmx-attributeStatusTable-rowMiddle nmx-attributeStatusTable-parameterName"
#dt = soup.find('span', class_ = re.compile("nmx-networkTreeItem-label nmx-networkTree-groupItem")).get_text().strip()



print(dt)
# selecionar os campos da primeira página

# Valores de rede.estação na barra esquerda, útil para mudar a página
# "nmx-networkTreeItem-label.nmx-networkTree-groupItem"

#<td class="nmx-attributeStatusTable-rowMiddle nmx-attributeStatusTable-parameterName">
#<td class="nmx-attributeStatusTable-rowMiddle nmx-attributeStatusTable-parameterValue">


#print(soup)