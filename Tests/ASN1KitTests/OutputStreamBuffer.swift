//
// Copyright (c) 2021 gematik GmbH
// 
// Licensed under the Apache License, Version 2.0 (the License);
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an 'AS IS' BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

class OutputStreamBuffer: OutputStream, StreamDelegate {
    var buffer: Data

    init(chunkSize: Int = 4096) {
        buffer = Data(capacity: chunkSize)
        let ptr = buffer.withUnsafeMutableBytes {
            // swiftlint:disable:next force_unwrapping
            return $0.baseAddress!.bindMemory(to: UInt8.self, capacity: chunkSize)
        }
        super.init(toBuffer: ptr, capacity: 0)
    }

    override func write(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) -> Int {
        self.buffer.append(buffer, count: len)
        return len
    }

    override var hasSpaceAvailable: Bool {
        return true
    }

    override var streamStatus: Status {
        return .open
    }

    func reset(chunkSize: Int = 4096) {
        buffer = Data(capacity: chunkSize)
    }
}
