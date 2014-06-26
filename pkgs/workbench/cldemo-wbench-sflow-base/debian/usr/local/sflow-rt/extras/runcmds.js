// author: Peter
// version: 1.2
// date: 5/8/2014
// description: Arista eAPI runCmds
// var s = new RpcServer('http://192.168.56.201/command-api','usr','passwd');
// var result = s.runCmds(["show version"]);

include('extras/jsonrpc.js');

RpcServer.prototype.runCmds = function(cmds,format) {
  try { return this.call('runCmds',{version:1,format:format ? format : 'json',cmds:cmds}); }
  catch(e) { throw e.message }
}
