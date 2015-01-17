import socket
import struct
import sys
import os
import random
import math

ok = 'ACK_OK'
DEBUG = False


#create and connect to the socket
def getSocket(host, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, int(port)))
    return s

def recvMessage(s):
    l = s.recv(4)
    L = struct.unpack('<I',l)[0]
    #print L
    data = ''
    while (len(data)<L):
        data += s.recv(L-len(data))
    return data

def sendMessage(s,mess):
    l = len(mess)
    byteLength = struct.pack('<I', l)
    s.sendall(byteLength)
    s.sendall(mess)

def closeSocket(s):
    s.close()

#registration
def reg(s,name, pwd):
    if (DEBUG):
        print (name, pwd)
    sendMessage(s,'r')
    data = recvMessage(s) #receive ack
    data = recvMessage(s) #receive username
    if (DEBUG):
        print data
    sendMessage(s,name) #send username
    data = recvMessage(s) #receive pwd
    if (DEBUG):
        print data
    sendMessage(s,pwd) #send pwd
    if (DEBUG):
        print pwd
    data = recvMessage(s) #receive status
    if (data!=ok): #error
        if (DEBUG):
            print data
            print ("reg error")
        return -1
    else:
        data = recvMessage(s) #receive confirm
        if (DEBUG):
            print data
        flag_id = data.split('<')[1]
        flag_id = flag_id.split('>')[0]
        if (DEBUG):
            print ("idstronzo label ",flag_id)
        return flag_id

#login
def login(s,usname,pwd):
    sendMessage(s,'l')
    data = recvMessage(s) #receive ACK
    if (DEBUG):
        print ("usname label ",usname, " pwd label", pwd)
    data = recvMessage(s) # receive username
    if (DEBUG):
        print data
    sendMessage(s,usname) #send username
    data = recvMessage(s) #receive pwd
    if (DEBUG):
        print data
    sendMessage(s,pwd) #send pwd
    data = recvMessage(s) # receive status
    if (data!=ok):
        return -1
    else:
        data = recvMessage(s) #receive confirm
        if (DEBUG):
            print data
        return 0

#help
def help(s, what):
    sendMessage(s,'h')
    data = recvMessage(s) # receive main menu
    data = recvMessage(s) # receive what help you want?
    if (DEBUG):
        print data
    sendMessage(s,what) #send command
    data = recvMessage(s) # receive ack
    if (data!=ok):
        return -1
    else:
        data = recvMessage(s) #receive help page
        if (DEBUG):
            print data
        return 0

#exit
def exit(s, input):
    sendMessage(s,'e')
    data = recvMessage(s) #receive main menu
    data = recvMessage(s) #receive menu exit
    if (DEBUG):
        print data
    sendMessage(s,input) #send command
    if (input == 'y' or input == 'Y'):
        return -1
    return 0

#insert_POI
def insert_poi(s,long, lat, flag):
    sendMessage(s,'a')
    data = recvMessage(s)
    data = recvMessage(s)
    data = recvMessage(s) #receive insert lat
    if (DEBUG):
        print data
    sendMessage(s,lat) #send lat
    if (DEBUG):
        print lat
    data = recvMessage(s) #receive insert long
    if (DEBUG):
        print data
    sendMessage(s,long) #send long
    if (DEBUG):
        print long
    data = recvMessage(s) #receive insert name
    if (DEBUG):
        print data
    sendMessage(s,flag) #send name
    if (DEBUG):
        print flag
    data = recvMessage(s) #receive status
    if (data != ok):
        return -1
    else:
        data = recvMessage(s) #receive confirm
        if (DEBUG):
            print data
        return 0

#view POI
def view_poi(s):
    sendMessage(s,'g')
    data = recvMessage(s) #receive ack
    data = recvMessage(s) #receive login status
    if (data != ok):
        return -1
    else:
        if (DEBUG):
            print ('logged')
        data = recvMessage(s) #receive list POI
        if (DEBUG):
            print data
        return 0