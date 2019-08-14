//
//  Response.swift
//  EAMAssetDataGenerator
//
//  Created by arvindh on 13/08/19.
//  Copyright © 2019 arvindh. All rights reserved.
//

import Foundation

class Response: NSObject, Codable {
  enum CodingKeys: String, CodingKey {
    case QueryE3MASSETResponse
  }
  
  var queryE3MASSETResponse: QueryE3MASSETResponse!
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.queryE3MASSETResponse = try container.decodeIfPresent(QueryE3MASSETResponse.self, forKey: Response.CodingKeys.QueryE3MASSETResponse)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(queryE3MASSETResponse, forKey: Response.CodingKeys.QueryE3MASSETResponse)
  }
  
}

class QueryE3MASSETResponse: NSObject, Codable {
  enum CodingKeys: String, CodingKey {
    case rsStart, rsCount, E3MASSETSet
  }
  
  var rsStart: Int = 0
  var rsCount: Int = 0
  var e3MASSETSet: E3MASSETSet!
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.e3MASSETSet = try container.decodeIfPresent(E3MASSETSet.self, forKey: .E3MASSETSet)
    self.rsStart = try container.decode(Int.self, forKey: .rsStart)
    self.rsStart = try container.decode(Int.self, forKey: .rsCount)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(rsStart, forKey: QueryE3MASSETResponse.CodingKeys.rsStart)
    try container.encode(rsCount, forKey: QueryE3MASSETResponse.CodingKeys.rsCount)
    try container.encode(e3MASSETSet, forKey: QueryE3MASSETResponse.CodingKeys.E3MASSETSet)
  }
}

class E3MASSETSet: NSObject, Codable {
  enum CodingKeys: String, CodingKey {
    case ASSET
  }
  
  var aSSET: [ASSET] = []
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.aSSET = try container.decode([ASSET].self, forKey: .ASSET)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(aSSET, forKey: E3MASSETSet.CodingKeys.ASSET)
  }
}

class ASSET: NSObject, Codable {
  enum CodingKeys: String, CodingKey {
    case rowstamp, ASSETHEALTH, ASSETNUM, ASSETUID, CHANGEBY, CHANGEDATE, C_OVERBUDGETCOST, DESCRIPTION, E3MPRIVATEID, GMPCRITICAL, ITEMSETID, LOCATION, PARENT, PLUSSISGIS, SITEID, STATUS
  }
  
  var rowstamp: String!
  var ASSETHEALTH: Int!
  var ASSETNUM: String!
  var ASSETUID: Int!
  var CHANGEBY: String!
  var CHANGEDATE: Date!
  var C_OVERBUDGETCOST: Double!
  var DESCRIPTION: String!
  var E3MPRIVATEID: String!
  var GMPCRITICAL: Bool = false
  var ITEMSETID: String!
  var LOCATION: String!
  var PARENT: String!
  var PLUSSISGIS: Bool = false
  var SITEID: String!
  var STATUS: String!

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.rowstamp = try container.decode(String.self, forKey: .rowstamp)
    self.ASSETHEALTH = try container.decode(Int.self, forKey: .ASSETHEALTH)
    self.ASSETNUM = try container.decode(String.self, forKey: .ASSETNUM)
    self.ASSETUID = try container.decode(Int.self, forKey: .ASSETUID)
    self.CHANGEBY = try container.decode(String.self, forKey: .CHANGEBY)
    self.C_OVERBUDGETCOST = try container.decode(Double.self, forKey: .C_OVERBUDGETCOST)
    self.DESCRIPTION = try container.decode(String.self, forKey: .DESCRIPTION)
    self.E3MPRIVATEID = try container.decode(String.self, forKey: .E3MPRIVATEID)
    self.GMPCRITICAL = try container.decode(Bool.self, forKey: .GMPCRITICAL)
    self.ITEMSETID = try container.decode(String.self, forKey: .ITEMSETID)
    self.LOCATION = try container.decode(String.self, forKey: .LOCATION)
    self.PARENT = try container.decode(String.self, forKey: .PARENT)
    self.PLUSSISGIS = try container.decode(Bool.self, forKey: .PLUSSISGIS)
    self.SITEID = try container.decode(String.self, forKey: .SITEID)
    self.STATUS = try container.decode(String.self, forKey: .STATUS)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(rowstamp, forKey: .rowstamp)
    try container.encode(ASSETHEALTH, forKey: .ASSETHEALTH)
    try container.encode(ASSETNUM, forKey: .ASSETNUM)
    try container.encode(ASSETUID, forKey: .ASSETUID)
    try container.encode(CHANGEBY, forKey: .CHANGEBY)
    try container.encode(CHANGEDATE, forKey: .CHANGEDATE)
    try container.encode(C_OVERBUDGETCOST, forKey: .C_OVERBUDGETCOST)
    try container.encode(DESCRIPTION, forKey: .DESCRIPTION)
    try container.encode(E3MPRIVATEID, forKey: .E3MPRIVATEID)
    try container.encode(GMPCRITICAL, forKey: .GMPCRITICAL)
    try container.encode(ITEMSETID, forKey: .ITEMSETID)
    try container.encode(LOCATION, forKey: .LOCATION)
    try container.encode(PARENT, forKey: .PARENT)
    try container.encode(PLUSSISGIS, forKey: .PLUSSISGIS)
    try container.encode(SITEID, forKey: .SITEID)
    try container.encode(STATUS, forKey: .STATUS)
  }
}
