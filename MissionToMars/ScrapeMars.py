
# coding: utf-8

# In[1]:

import splinter
from splinter import Browser
from bs4 import BeautifulSoup
import pandas
import requests
import shutil

def scrapeMars():
    # In[2]:


    #scrape for recent Mars headline from NASA news site
    executable_path = {'executable_path': 'chromedriver.exe'}
    browser = Browser('chrome', **executable_path, headless=True)
    url = 'https://mars.nasa.gov/news'
    browser.visit(url)


    # In[3]:


    soup = BeautifulSoup(browser.html, 'lxml')


    # In[4]:


    news_title = soup.find('div', class_='content_title').a.text


    # In[5]:


    news_p = soup.find('div', class_="article_teaser_body").text


    # In[6]:


    # scrape for JPL Mars Space images

    url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
    browser.visit(url)
    stew = BeautifulSoup(browser.html, 'lxml')


    # In[7]:


    featured_image_url = stew.find('section', 'grid_gallery module grid_view').find(
                                    'a', 'fancybox')['data-fancybox-href']


    # In[8]:


    featured_image_url = "https://www.jpl.nasa.gov" + featured_image_url


    # In[9]:


    #Scrape Twitter @MarsWxReport

    url = "https://twitter.com/marswxreport?lang=en"
    browser.visit(url)
    posole = BeautifulSoup(browser.html, 'lxml')


    # In[10]:


    mars_weather = posole.find('p', class_="TweetTextSize TweetTextSize--normal js-tweet-text tweet-text").text


    # In[11]:


    #Scrape https://space-facts.com/mars/ for tabular data
    url = "https://space-facts.com/mars/"
    mars_table = pandas.read_html(url)


    # In[12]:


    #Scrape for image links

    url = "https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars"
    browser.visit(url)
    hemisphere_soup = BeautifulSoup(browser.html, 'lxml')


    # In[13]:


    image_links = hemisphere_soup.find_all('div', class_='description')
    titles = hemisphere_soup.find_all('h3')


    # In[14]:


    hemisphere_image_urls = []
    for i in range(len(image_links)):
        #format image url
        image_url = "https://astrogeology.usgs.gov" + image_links[i].a['href']
        
        #format title
        string_list = (titles[i].text).split(" ")
        title = ' '.join(string_list[:-1])
        
        image_dict = {"title":title, "img_url" : image_url}
        hemisphere_image_urls.append(image_dict)


    # In[15]:


    #replace url with url to full-size image

    for i in range(len(hemisphere_image_urls)):
        browser.visit(hemisphere_image_urls[i]['img_url'])
        soup = BeautifulSoup(browser.html, 'lxml')
        
        img_source_url = 'https://astrogeology.usgs.gov' + soup.find('img', class_="wide-image")['src']
        hemisphere_image_urls[i]['img_url'] = img_source_url


    # In[17]:


    mars_scrape_dict = {
        'news_title':news_title,
        'news_paragraph':news_p,
        'mars_weather':mars_weather,
        'mars_facts':mars_table,
        'JPLfeatured_image':featured_image_url,
        'hemispheres':hemisphere_image_urls
    }

    return mars_scrape_dict