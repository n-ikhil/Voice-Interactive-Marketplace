from django.shortcuts import render
from bs4 import BeautifulSoup
import requests

# Create your views here.

def get_query(request):
	if request.method=='POST':
		s1 = request.POST['obj']
		s2 = request.POST['place']
		# print(s1,s2)
		print("googling...")
		link = requests.get('https://www.google.com/search?q=' + s1 + ' in ' + s2)
		link.raise_for_status()
		search = link.text
		soup = BeautifulSoup(search,'lxml')
		linkElements = soup.find_all('a')
		flag = False
		l1 = []
		for i in range(len(linkElements)):
			if flag==True:
				break
			try :
				#print(linkElements[i].span.text)
				spans = linkElements[i].find_all('span')
				for sp in spans:
					if flag==True:
						break;
					try:
						s1 = str(sp.text)
						if s1.__contains__('More places'):
							flag = True
						elif(len(s1)>7):
							l1.append(s1)
							print(s1)
					except Exception as e:
						print("\n@\n")
			except Exception as e:
				print("\n$\n")
		# n = int(len(l1)/3)
		# l2 = []
		# for i in range(0,n):
		# 	l2.append({'name':l1[3*i+0],'address':l1[3*i+1],'rating':l1[3*i+2]})

		# data = {'text':l2}
		
		# print(l2)

		i=0
		l2=[]
		while(i < len(l1)-2):
			# print(i)
			s1 = l1[i].lstrip('0123456789,.-() ')
			s2 = l1[i+1].lstrip('0123456789,.-() ')
			s3 = l1[i+1][:len(l1[i+1])-len(s2)]
			# print(s1,s2,s3)
			i = i+1
			if s2=='' or s1 == '' :
				continue
			else :
				l2.append({'name':s1,'address':s2,'rating':s3})
			


		data = {'text':l2}
		return render(request,'main.html',data)



	return render(request,'base.html')