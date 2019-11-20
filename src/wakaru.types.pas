{ wakaru

  Copyright (c) 2019 mr-highball

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to
  deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
  sell copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
  IN THE SOFTWARE.
}
unit wakaru.types;

{$mode delphi}{$H+}

interface

uses
  Classes,
  SysUtils,
  wakaru.consts,
  wakaru.collection;

type

  { IIdentifiable }
  (*
    a means of identifying uniquely, and optionally with a user defined tag
  *)
  IIdentifiable = interface
    ['{22B4C03D-52C8-4578-AD9C-D2A9A054F70C}']

    //property methods
    function GetID: String;
    function GetTag: String;
    procedure SetTag(AValue: String);

    //properties

    (*
      unique generated identifier
    *)
    property ID : String read GetID;

    (*
      "friendly" identifier that can be modified by caller
    *)
    property Tag : String read GetTag write SetTag;
  end;

  //forward
  INode = interface;

  { INodes }
  (*
    a collection of nodes
  *)
  INodes = IInterfaceCollection<INode>;

  { INodeConnection }
  (*
    a node connection binds node(s) together but always has only
    one source node
  *)
  INodeConnection = interface
    ['{1187154A-EF72-4BF5-A975-D28FA418726D}']

    //property methods
    function GetSource: INode;
    procedure SetSource(AValue: INode);
    function GetConnected: INodes;

    //properties
    property Source : INode read GetSource write SetSource;
    property Connected : INodes read GetConnected;

    //methods
  end;

  { INodeConnections }
  (*
    a collection of node connections
  *)
  INodeConnections = IInterfaceCollection<INodeConnection>;

  (*
    nodes are interconnected constructs that accept
    signals and express a value. additionally, nodes transmit
    signals through node connections when thresholds are met
  *)
  INode = interface
    ['{0B7F6660-5A94-4F70-8434-E9865A2C7004}']

    //property methods
    function GetConnections: INodeConnections;
    function GetID: IIdentifiable;
    function GetRawValue: TSignalRange;
    function GetValue: TSignal;
    procedure SetRawValue(AValue: TSignalRange);
    procedure SetValue(AValue: TSignal);

    //properties
    property Connections : INodeConnections read GetConnections;
    property Value : TSignal read GetValue write SetValue;
    property RawValue : TSignalRange read GetRawValue write SetRawValue;
    property ID : IIdentifiable read GetID;

    //methods

    (*
      resets the node's value to the default resting state
    *)
    procedure Reset();

    (*
      passes a signal value to this node which may or may not
      affect this node's value, and connected downstream nodes
    *)
    procedure Signal(constref AValue : TSignalRange);
  end;

  (*
    a node cluster is a collection of connected nodes and has the
    roles of taking the signal measurement of all nodes, as well as
    distributing incoming external signal information
  *)

  { INodeCluster }

  INodeCluster = interface
    ['{53CF34C9-D26E-475A-B412-34239499824F}']

    //property methods
    function GetID: IIdentifiable;
    function GetNodes: INodes;

    //properties
    property Nodes : INodes read GetNodes;
    property ID : IIdentifiable read GetID;

    //methods

    (*
      calculates the signal value of all contained nodes
    *)
    property Value() : TSignal;
  end;

  (*
    the network is a collection of at least one node cluster. primary
    responsibilities include distributing external signals to clusters,
    maintaining the "pulse", and recording finalized signals for the clusters
    for a given pulse. this can also be seen as the top level interface
    when working with nodes
  *)
  INodeNetwork = interface
    ['{821D75CF-455A-434B-9406-29B3CA0CA224}']

    //properties
    property ID : IIdentifiable read GetID;

    //methods

    (*
      stores current signals to the "working" pulse tree for all clusters
    *)
    procedure Pulse();

    (*
      stores entire tree to "memory" with an optional session identifier
    *)
    //Commit()

    (*
      clears the "working tree" and resets all nodes inside of all
      clusters to their default state
    *)
    //Clear()
  end;

implementation

end.

