from django.shortcuts import render
# from .services.webscraping import WebData
# from django.shortcuts import render
# from bs4 import BeautifulSoup
# import requests
from django.http import HttpResponse,JsonResponse
from rest_framework.parsers import JSONParser
from profiles.models import User
from marketplace.models import Provider,Seeker,Product,StandardProduct
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







def removeProduct(request):
	pass
def queryProduct(request):
	pass
def getProductInfo(request):
	pass




@csrf_exempt
@api_view(["POST"])
@permission_classes((IsAuthenticated,))
def providerRegistration(request):

	if request.method == 'POST':
		data = JSONParser().parse(request)
		usr = request.user
		try:
			title = data['title']
			address = data['address']
			description = ''
			try:
				description = data['description']
			except Exception as e:
				print('no description')
		except Exception as e:
			return JsonResponse({"info":"please provide all the fields",'status':False})


		try:
			pd = Provider.objects.filter(user=usr)
			if pd.__len__()==0:
				pvd = Provider(user= usr,title=title,description=description,address=address)
				pvd.save()
				final_data = {'info':'created successfully','status':True}
			else:
				final_data = {'info':'already registered','status':False}
		except Exception as e:
			raise e
			final_data = {'info':'error in creating Provider','status':False}

		return JsonResponse(final_data,safe=False)




@csrf_exempt
@api_view(["GET"])
@permission_classes((IsAuthenticated,))
def getSellerProductList(request):
	if request.method == 'GET':
		try:
			usr = request.user
			p = Provider.objects.filter(user=usr)
			if p.__len__()==0:
				final_data = {'info':'first register by giving the company name and details','hint':'call provider_registration','status':False}
			else :
				product_list = Product.objects.filter(owner=usr)
				final_data = {}
				for p in product_list:
					tmp = {}
					tmp['name'] = p.pId.name
					tmp['mode'] = p.mode
					tmp['location'] = p.location
					final_data[p.id] = tmp
				final_data['status'] = True
		except Exception as e:
			final_data = {'info':'Incorrect Parameters or no data for given Parameters','status':False}
			print('no data')

		return JsonResponse(final_data,safe=False)




@csrf_exempt
@api_view(["POST"])
@permission_classes((IsAuthenticated,))
def addProduct(request):

	if request.method == 'POST':
		data = JSONParser().parse(request)
		usr = request.user
		provider = Provider.objects.get(user=usr)
		try:
			name = data['name']
			location = data['location']
			mode = data['mode']
		except Exception as e:
			return JsonResponse({"info":"please provide all the fields",'status':False})


		try:
			spd = StandardProduct.objects.filter(name = name)
			if spd.__len__()==0:
				std = StandardProduct(name=name)
				std.save()
			std = StandardProduct.objects.get(name=name)
			pd = Product.objects.filter(pId=std,owner=usr,location=location,mode=mode)
			if pd.__len__()==0:
				pvd = Product(owner=usr,pId=std,location=location,mode=mode)
				pvd.save()
				product_list = Product.objects.filter(owner=usr)
				final_data = {}
				for p in product_list:
					tmp = {}
					tmp['name'] = p.pId.name
					tmp['mode'] = p.mode
					tmp['location'] = p.location
					final_data[p.id] = tmp
				final_data['status'] = True
			else:
				final_data = {'info':'product with same details already existing','status':False}
		except Exception as e:
			final_data = {'info':'error in creating Provider','status':False}

		return JsonResponse(final_data,safe=False)





@csrf_exempt
@api_view(["GET"])
@permission_classes((IsAuthenticated,))
def getBuyerProductList(request):

	if request.method == 'GET':
		usr = request.user
		data = JSONParser().parse(request)
		try:
			name = data['product']
			place = data['place']
		except Exception as e:
			return JsonResponse({"info":"please provide all the fields",'status':False})

		try:

			spd = StandardProduct.objects.filter(name=name)
			if spd.__len__()==0:
				return JsonResponse({"info":"product name does not exist in StandardProduct",'status':False})
			std = StandardProduct.objects.get(name=name)
			print(std)
			pvd = Product.objects.filter(pId__name = name,location__contains = place)
			print(pvd)
			final_data = {}
			provider = Provider.objects.get(user=usr)
			print(provider)
			for p in pvd:
				tmp = {}
				tmp['title'] = provider.title
				tmp['phno'] = p.owner.phno
				tmp['location'] = p.location
				tmp['username'] = p.owner.username
				tmp['description'] = provider.description
				final_data[p.id] = tmp
			# pvd = Provider.objects.filter(services__contains=data['service'],address__contains=data['place'])
			# ser = ProviderSerializer(pvd,many=True)
			# final_data = ser.data
			print(final_data)
			final_data['status'] = True
		except Exception as e:
			final_data = {'info':'Incorrect Parameters or no data for given Parameters','status':False}
			print('no data')

		return JsonResponse(final_data,safe=False)
