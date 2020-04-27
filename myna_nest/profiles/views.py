from django.shortcuts import render
from bs4 import BeautifulSoup
import requests
from django.http import HttpResponse,JsonResponse
from rest_framework.parsers import JSONParser
from .models import User
from marketplace.models import Provider,Seeker
from django.views.decorators.csrf import csrf_exempt
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view, permission_classes,renderer_classes
from rest_framework.permissions import AllowAny,IsAuthenticated
from rest_framework.status import (
    HTTP_400_BAD_REQUEST,
    HTTP_404_NOT_FOUND,
    HTTP_200_OK
)
from rest_framework.renderers import JSONRenderer, TemplateHTMLRenderer
from django.forms.models import model_to_dict



# Create your views here.
@csrf_exempt
@api_view(["POST"])
@permission_classes((AllowAny,))
def get_query(request):
	if request.method=='POST':
		s1 = request.data.get('service')
		s2 = request.data.get('place')
		print(s1,s2)
		try:
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
			l2={}
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
			#return render(request,'main.html',data)
			return JsonResponse(data,status=201)
		except Exception as e:
			return JsonResponse({"status":"no internet connection"},status=201)


	return render(request,'base.html')








@csrf_exempt
@api_view(["POST"])
@permission_classes((AllowAny,))
def login(request):
	email = request.data.get("email")
	password = request.data.get("password")
	if email is None or password is None:
		return Response({'info': 'Please provide both email and password','status':False},
			status=HTTP_400_BAD_REQUEST)
	user_cur = authenticate(email = email,password = password)
	print(user_cur)
	if not user_cur:
		return Response({'error': 'Invalid Credentials','status':False},
				status=HTTP_404_NOT_FOUND)
	token, _ = Token.objects.get_or_create(user=user_cur)
	return Response({'token': token.key,'status':True},
				status=HTTP_200_OK)



@csrf_exempt
@api_view(["POST"])
@permission_classes((AllowAny,))
def registration(request):
	if request.method=='POST':
		data = JSONParser().parse(request)
		try:
			password = data["password"]
			email = data["email"]
			username = data['username']
			phno = data['phno']
			address = data['address']
			language = data['language']
		except Exception as e:
			return JsonResponse({"info":"please provide all the fields",'status':False})
		
		try:
			if User.objects.filter(email = email).__len__()==0:
				usr = User.objects.create_user(email=email,password=password,username=username,phno = phno,address=address,language=language)
				usr.save()
				return JsonResponse({"email":usr.email,"info":"user created successfully","status":True})
			else:
				return JsonResponse({"info":"email already existing","status":False},status=201)
		except Exception as e:
			raise e
		
		return JsonResponse({"info":"unable to create user","status":False})

	return HttpResponse("<h5>error: request method must be post with the details of registration</h5>")


