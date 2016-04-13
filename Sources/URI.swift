// Original code from
// https://github.com/Zewo/URI/
// https://github.com/Zewo/String/

import CURIParser
@_exported import C7

extension String {
    func subscring(start: UInt16, end: UInt16) -> String {
        return self[startIndex.advanced(by: Int(start)) ..< startIndex.advanced(by: Int(end))]
    }
    
    func split(separator: Character) -> [String] {
        return characters.split(separator: separator).map(String.init)
    }
}

extension URI {
    public init(_ string: String) throws {
        let u = parse_uri(string)

        scheme = u.field_set & UInt16(1) != 0
            ? string.subscring(u.scheme_start, end: u.scheme_end)
            : nil

        host = u.field_set & UInt16(2) != 0
            ? string.subscring(u.host_start, end: u.host_end)
            : nil

        port = u.field_set & UInt16(4) != 0
            ? Int(u.port)
            : 80

        path = u.field_set & UInt16(8) != 0
            ? string.subscring(u.path_start, end: u.path_end)
            : nil

        if u.field_set & UInt16(16) != 0 {
            let queryString: String = string.subscring(u.query_start, end: u.query_end)
            query = URI.parseQueryString(queryString)
        } else {
            query = [:]
        }

        fragment = u.field_set & UInt16(32) != 0
            ? string.subscring(u.fragment_start, end: u.fragment_end)
            : nil

        if u.field_set & UInt16(64) != 0 {
            let stuff: String = string.subscring(u.user_info_start, end: u.user_info_end)
            let pair = stuff.split(":")
            if pair.count == 1 {
                userInfo = UserInfo(username: pair[0], password: "")
            } else {
                userInfo = UserInfo(username: pair[0], password: pair[1])
            }
        } else {
            userInfo = nil
        }
    }
    
    static func parseQueryString(queryString: String) -> Query {
        var query: Query = [:]
        let tuples = queryString.split("&")
        for tuple in tuples {
            let pair = tuple.split("=")
            if pair.count == 1 {
                query[pair[0]] = QueryField([])
            } else if pair.count == 2 {
                query[pair[0]].append(pair[1])
            }
        }
        return query
    }
}

public enum URIParseError : ErrorProtocol {
    case invalidURI
}
