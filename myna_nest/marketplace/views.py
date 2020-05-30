from django.shortcuts import render
# from .services.webscraping import WebData
# from django.shortcuts import render
# from bs4 import BeautifulSoup
# import requests
from django.http import HttpResponse,JsonResponse
from rest_framework.parsers import JSONParser
from profiles.models import User
from marketplace.models import Product,StandardProduct,Category
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
from .serializers import CategorySerializer,StandardProductSerializer






@csrf_exempt
@api_view(["POST"])
@permission_classes((IsAuthenticated,))
def removeProduct(request):
	if request.method == 'POST':
		data = JSONParser().parse(request)
		usr = request.user
		try:
			product_id = data['id']
		except Exception as e:
			return JsonResponse({"info":"please provide all the fields",'status':False})

		try:
			try:
				product = Product.objects.get(id=product_id)
			except Exception as e:
				return JsonResponse({"info":"No product with given id",'status':False})
			product.delete()
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
@api_view(["GET"])
@permission_classes((IsAuthenticated,))
def getProductInfo(request):
	if request.method == 'GET':
		data = JSONParser().parse(request)
		usr = request.user
		try:
			product_id = data['id']
		except Exception as e:
			return JsonResponse({"info":"please provide all the fields",'status':False})

		try:
			try:
				product = Product.objects.get(id=product_id)
			except Exception as e:
				return JsonResponse({"info":"No product with given id",'status':False})
			
			final_data = {}
			final_data['name'] = product.pId.name
			final_data['mode'] = product.mode
			final_data['location'] = product.location
			final_data['owner'] = product.owner.username
			final_data['owner_location'] = product.owner.address 
			final_data['owner_phno'] = product.owner.phno
			final_data['owner_email'] = product.owner.email 
			final_data['status'] = True
		except Exception as e:
			final_data = {'info':'Incorrect Parameters or no data for given Parameters','status':False}
			print('no data')
		return JsonResponse(final_data,safe=False)


@csrf_exempt
@api_view(["GET"])
@permission_classes((IsAuthenticated,))
def sellerProductList(request):
	if request.method == 'GET':
		try:
			usr = request.user
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
def queryProduct(request):

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
			for p in pvd:
				tmp = {}
				tmp['phno'] = p.owner.phno
				tmp['location'] = p.location
				tmp['username'] = p.owner.username
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



@csrf_exempt
@api_view(["GET"])
@permission_classes((IsAuthenticated,))
def getCategoryList(request):
	if request.method == 'GET':
		usr = request.user
		try:
			categorylist = Category.objects.all()
			if categorylist.__len__()==0:
				final_data = {'info':'no elements in category list','status':False}
			else :
				final_data = {}
				ser = CategorySerializer(categorylist,many=True)
				final_data['category_list'] = ser.data
				final_data['status'] = True
		except Exception as e:
			final_data = {'info':'error in getting category list','status':False}
			print('no data')

		return JsonResponse(final_data,safe=False)

@csrf_exempt
@api_view(["GET"])
@permission_classes((IsAuthenticated,))
def getProductList(request):
	if request.method == 'GET':
		usr = request.user
		data = JSONParser().parse(request)
		try:
			category = data['category']
		except Exception as e:
			return JsonResponse({"info":"please provide all the fields",'status':False})

		try:
			final_data = {}
			product_list = StandardProduct.objects.filter(category__name=category)
			ser = StandardProductSerializer(product_list,many=True)
			final_data['product_list'] = ser.data
			final_data['status'] = True
		except Exception as e:
			final_data = {'info':'error in getting product list for given category','status':False}
			print('no data')

		return JsonResponse(final_data,safe=False)
