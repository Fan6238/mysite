import List "mo:base/List";
import Iter "mo:base/Iter";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
actor {
    public type Message = {
        text : Text;
        time : Int;
    };
    public type Microblog = actor {
        follow : shared (Principal) -> async ();
        follows : shared query () -> async [Principal];
        post : shared (Text) -> async ();
        posts : shared query (Int) -> async [Message];
        timeline : shared () -> async [Message];
    };
    var followed : List.List<Principal> = List.nil();
    public shared func follow(id : Principal) : async () {
        let exist = List.some<Principal>(
            followed, 
            func(id){id==id;}
        );
        if (exist == false) {
            followed := List.push(id, followed);
        };
    };
    public shared query func follows() : async [Principal] {
        List.toArray(followed);
    };
    var messages : List.List<Message> = List.nil();
    public shared (msgCall) func post(text : Text) : async () {
        assert(Principal.toText(msgCall.caller) == "b5k7c-lyygt-7pbfs-7d5ym-w2qhb-z6epe-ifszn-sd424-ivm4t-3mcwk-rqe");
        let msg : Message = {
            text = text;
            time = Time.now();
        };
        messages := List.push(msg, messages);
    };
    public shared query func posts(since : Time.Time) : async [Message] {
        var all : List.List<Message> = List.nil();
        for (msg in Iter.fromList(messages)) {
            if (msg.time >= since) {
                all := List.push(msg, all);
            };
        };
        List.toArray(all);
    };
    public shared func timeline(since : Time.Time) : async [Message] {
        var all : List.List<Message> = List.nil();
        for (id in Iter.fromList(followed)) {
            let canister : Microblog = actor(Principal.toText(id));
            try {
                let msgs : [Message] = await canister.posts(since);
                for (msg in Iter.fromArray(msgs)) {
                    if (msg.time >= since) {
                        all := List.push(msg, all);
                    };
                };
            } catch (err) {};
        };
        List.toArray(all);
    };
}

/*
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
*/
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