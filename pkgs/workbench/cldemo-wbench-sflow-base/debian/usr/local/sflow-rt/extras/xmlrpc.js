// author: Peter
// version: 1.0
// date: 4/7/2014
// description: XML-RPC 2.0 client

function RpcServer(url,usr,passwd) {
  this.url = url;
  this.usr = usr;
  this.passwd = passwd;
  this.call = function(method,params) {
    var req = <methodCall><methodName>{method}</methodName><params/></methodCall>;
    req.methodName = method;
    if(params) {
      for(var i = 0; i < params.length; i++) {
        var type = typeof params[i];
        switch(type) {
          case 'number':
            req.params += <parameter><double>{params[i]}</double></parameter>;
            break;
          default:
            req.params += <parameter><string>{params[i]}</string></parameter>;
        }
      }
    }
    var resp = http(this.url,'post','application/xml-rpc','<?xml version="1.0"?>'+req,this.usr,this.passwd);
    if(resp) {
      resp = resp.replace(/<\?xml[^>]*\?>/, "").trim();
      resp = new XML(resp);
      ans = [];
      for each (var value in resp..value) {
        var val = value.children()[0];
        switch('' + val.name()) {
          case 'int':
            ans.push(parseInt(val.text()));
            break;
          case 'double':
            ans.push(parseFloat(val.text()));
            break;
          default:
            ans.push(val.text());
        }
      }
      return ans;
    }
    return resp;
  }
}

