import Nat "mo:base/Nat";
import Text "mo:base/Text";

actor Counter {

    stable var currentValue : Nat = 0;

    public query func get() : async Nat {
        currentValue
    };

    public func increment() : async () {
        currentValue += 1;
    };

    public func set(n: Nat) : async () {
        currentValue := n;
    };

    public type Key = Text;
    public type Path = Text;
    public type ChunkId = Nat;
    public type HeaderField = (Text, Text);

    public type SetAssetContentArguments = {
        key : Key;
        sha256 : ?[Nat8];
        chunk_ids : [ChunkId];
        content_encoding : Text;
    };

    public type StreamingCallbackToken = {
        key : Text;
        sha256: [Nat8];
        index : Nat;
        content_encoding : Text;
    };

    public type StreamingCallbackHttpresponse = {
        token : ?StreamingCallbackToken;
        body : [Nat8];
    };

    public type StreamingStragegy = {
        #Callback : {
            token : StreamingCallbackToken;
            callback : shared query StreamingCallbackToken -> async StreamingCallbackHttpresponse;
        };
    };

    public type HttpRequest = {
        body : [Nat8];
        headers : [HeaderField];
        method : Text;
        url : Text;
    };

    public type HttpResponse = {
        body : Blob;
        headers : [HeaderField];
        streaming_stragegy : ?StreamingStragegy;
        status_code : Nat16;
    };

    public shared query func http_request() : async HttpResponse {
        {
            body = Text.encodeUtf8("<html><body>The current counter value is : " # Nat.toText(currentValue) # "</body></html>");
            headers = [];
            streaming_stragegy = null;
            status_code = 200;
        }
    };
}

/*
import Array "mo:base/Array";
actor Counter {
    func quicksort(a : [var Int]) : [var Int] {
        var i = 0;
        while (i < a.size()) {
            var j = 1;
            while (j < a.size()) {
                if (a[j -1] > a[j]) {
                    let n = a[j -1];
                    a[j - 1] := a[j];
                    a[j] := n;
                };
                j := j + 1;
            };
            i := i + 1;
        };
        return a;
    };
    public func qsort(arr : [Int]) : async [Int] {
        Array.freeze(quicksort(Array.thaw(arr))); 
    };
}
*/
