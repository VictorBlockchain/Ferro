// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        _status = _ENTERED;

        _;
        _status = _NOT_ENTERED;
    }
}

interface IERC721Receiver {

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721Holder is IERC721Receiver {

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}

pragma solidity ^0.8.1;
library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                /// @solidity memory-safe-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
library SafeMath {

    uint constant TEN9 = 10**9;
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {

    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath#mul: OVERFLOW");

    return c;
  }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a, "SafeMath#sub: UNDERFLOW");
    uint256 c = a - b;

    return c;
  }
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath#add: OVERFLOW");

    return c;
  }
}
pragma solidity ^0.8.0;
interface IERC20Permit {
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function nonces(address owner) external view returns (uint256);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}
interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }
    function _callOptionalReturn(IERC20 token, bytes memory data) private {

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
abstract contract ERC165 is IERC165 {


    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

interface IERC1155Receiver is IERC165 {

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
    }
}

contract ERC1155Holder is ERC1155Receiver {
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
}

interface IERC721 is IERC165 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    function approve(address to, uint256 tokenId) external;
    function setApprovalForAll(address operator, bool _approved) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

interface IERC1155 is IERC165 {
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    event URI(string value, uint256 indexed id);
    function balanceOf(address account, uint256 id) external view returns (uint256);
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
        external
        view
        returns (uint256[] memory);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address account, address operator) external view returns (bool);
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}
interface IERC1155MetadataURI is IERC1155 {
    /**
     * @dev Returns the URI for token type `id`.
     *
     * If the `\{id\}` substring is present in the URI, it must be replaced by
     * clients with the actual token type ID.
     */
    function uri(uint256 id) external view returns (string memory);
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() {
        _transferOwnership(_msgSender());
    }
    modifier onlyOwner() {
        _checkOwner();
        _;
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
    using Address for address;

    mapping(uint256 => mapping(address => uint256)) private _balances;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    string private _uri;

    constructor(string memory uri_) {
        _setURI(uri_);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            super.supportsInterface(interfaceId);
    }
    function uri(uint256) public view virtual override returns (string memory) {
        return _uri;
    }
    function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
        require(account != address(0), "ERC1155: balance query for the zero address");
        return _balances[id][account];
    }
        function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        public
        view
        virtual
        override
        returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }
    function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];
    }
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );
        _safeTransferFrom(from, to, id, amount, data);
    }
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: transfer caller is not owner nor approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }
    function _safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }
        _balances[id][to] += amount;

        emit TransferSingle(operator, from, to, id, amount);

        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
    }
    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
            _balances[id][to] += amount;
        }

        emit TransferBatch(operator, from, to, ids, amounts);

        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
    }
    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }
    function _mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);

        _balances[id][to] += amount;
        emit TransferSingle(operator, address(0), to, id, amount);

        _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
    }
    function _mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] += amounts[i];
        }

        emit TransferBatch(operator, address(0), to, ids, amounts);

        _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
    }
    function _burn(
        address from,
        uint256 id,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }

        emit TransferSingle(operator, from, address(0), id, amount);
    }
    function _burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
        }

        emit TransferBatch(operator, from, address(0), ids, amounts);
    }
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC1155: setting approval status for self");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {}

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
                bytes4 response
            ) {
                if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }

    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}
abstract contract ERC1155Supply is ERC1155 {
    mapping(uint256 => uint256) private _totalSupply;

    /**
     * @dev Total amount of tokens in with a given id.
     */
    function totalSupply(uint256 id) public view virtual returns (uint256) {
        return _totalSupply[id];
    }

    /**
     * @dev Indicates whether any token exist with a given id, or not.
     */
    function exists(uint256 id) public view virtual returns (bool) {
        return ERC1155Supply.totalSupply(id) > 0;
    }

    /**
     * @dev See {ERC1155-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);

        if (from == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                _totalSupply[ids[i]] += amounts[i];
            }
        }

        if (to == address(0)) {
            for (uint256 i = 0; i < ids.length; ++i) {
                _totalSupply[ids[i]] -= amounts[i];
            }
        }
    }
}
abstract contract ERC1155Burnable is ERC1155 {
    function burn(
        address account,
        uint256 id,
        uint256 value
    ) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );

        _burn(account, id, value);
    }

    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory values
    ) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "ERC1155: caller is not owner nor approved"
        );

        _burnBatch(account, ids, values);
    }
}
interface i369{

    function GETCIRCULATINGSUPPLY(uint256 tokenid_) external pure returns(uint256);
    function GETPRICEDTOSUPPLY(uint256 tokenid_) external pure returns(uint256, uint256, uint256, uint256, uint256);
    function GETPRICEDTOSWAPSUPPLY(uint256 tokenin_, uint256 tokenout_) external view returns(uint256, uint256, uint256, uint256, uint256, uint256,uint256,uint256);

}

contract NFTWALLET is ERC721Holder, ERC1155Holder {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    event deposit(
        address sender,
        uint256 amount,
        address x0
    );
    event withdraw(

        address receiver,
        uint256 amount,
        address x0
    );
    bytes4 private constant INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant INTERFACE_ID_ERC1155 = 0xd9b67a26;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public _nftcontract;
    uint256 public _nftid;
    uint256 public _unlockdate;

    constructor(address nftcontract_, uint256 nftid_) {

      _nftcontract = nftcontract_;
      _nftid = nftid_;
    }

    receive () external payable {}

    function holdnft(address nftcontract_, uint256 tokenid_, address nftincontract_, uint256 nftintokenid_, uint256 nftinquantity_) public {

          require(nftcontract_ == _nftcontract && tokenid_ == _nftid, 'this wallet is not for that nft');

      if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

          IERC721 nft = IERC721(nftcontract_);
          require(nft.ownerOf(tokenid_) == msg.sender, "you do not have this nft");

          require(nft.isApprovedForAll(msg.sender, address(this)), "item not approved");
          nft.safeTransferFrom(msg.sender, address(this), tokenid_);

      } else if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

          IERC1155 nft = IERC1155(nftcontract_);
          require(nft.balanceOf(msg.sender, tokenid_) >= nftinquantity_, "you have nnot enough");
          nft.safeTransferFrom(msg.sender, address(this), tokenid_, nftinquantity_, bytes(""));

      } else {

          revert("invalid nft address");
      }

      if (IERC165(nftincontract_).supportsInterface(INTERFACE_ID_ERC721)) {

          IERC721 nft = IERC721(nftincontract_);
          require(nft.ownerOf(nftintokenid_) == msg.sender, "you do not have this nft");

          require(nft.isApprovedForAll(msg.sender, address(this)), "item not approved");
          nft.safeTransferFrom(msg.sender, address(this), nftintokenid_);

      } else if (IERC165(nftincontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

          IERC1155 nft = IERC1155(nftincontract_);
          require(nft.balanceOf(msg.sender, nftintokenid_) >= nftinquantity_, "you have nnot enough");
          nft.safeTransferFrom(msg.sender, address(this), nftintokenid_, nftinquantity_, bytes(""));

      } else {

          revert("invalid nft address");
      }

    }

    function transfernft(address nftcontract_, uint256 tokenid_, address nftoutcontract_, uint256 nftouttokenid_, uint256 nftoutquantity_) public {

      require(nftcontract_ == _nftcontract && tokenid_ == _nftid, 'this wallet is not for that nft');


      if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

          IERC721 nft = IERC721(nftcontract_);
          require(nft.ownerOf(tokenid_) == msg.sender, "you do not own this nft");

      } else if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

          IERC1155 nft = IERC1155(nftcontract_);
          require(nft.balanceOf(msg.sender, tokenid_) > 0, "you do not own this nft");

      } else {

          revert("invalid nft address");
      }

      if (IERC165(nftoutcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

          IERC721 nft = IERC721(nftoutcontract_);
          require(nft.ownerOf(nftouttokenid_) == address(this), "nft not in this wallet");
          nft.safeTransferFrom(address(this), msg.sender, nftouttokenid_);

      } else if (IERC165(nftoutcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

          IERC1155 nft = IERC1155(nftoutcontract_);
          require(nft.balanceOf(address(this), nftouttokenid_) > nftoutquantity_, "not enough nfts in this wallet");
            nft.safeTransferFrom(address(this), msg.sender, nftouttokenid_, nftoutquantity_, '');

      } else {

          revert("invalid nft address");
      }
    }

    function withdraweth(address nftcontract_, uint256 tokenid_) public returns(bool){

      require(nftcontract_ == _nftcontract && tokenid_ == _nftid, 'this wallet is not for that nft');

      if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

          IERC721 nft = IERC721(nftcontract_);
          require(nft.ownerOf(tokenid_) == msg.sender, "you do not own this nft");

      } else if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

          IERC1155 nft = IERC1155(nftcontract_);
          require(nft.balanceOf(msg.sender, tokenid_) > 0, "you do not own this nft");

      } else {

          revert("invalid nft address");
      }
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        return success;
    }

    function transfertoken(address nftcontract_, uint256 tokenid_, address token_, uint256 value_) public {

      require(nftcontract_ == _nftcontract && tokenid_ == _nftid, 'this wallet is not for that nft');

      if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

          IERC721 nft = IERC721(nftcontract_);
          require(nft.ownerOf(tokenid_) == msg.sender, "you do not own this nft");

      } else if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

          IERC1155 nft = IERC1155(nftcontract_);
          require(nft.balanceOf(msg.sender, tokenid_) > 0, "you do not own this nft");

      } else {

          revert("invalid nft address");
      }

      require(IERC20(token_).balanceOf(address(this))>= value_ , 'balance not equal to value');
      IERC20(token_).safeTransfer(msg.sender,value_);

    }

    function lockwallet(address nftcontract_, uint256 tokenid_, uint256 untiltime_) public {

      require(nftcontract_ == _nftcontract && tokenid_ == _nftid, 'this wallet is not for that nft');

      if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

          IERC721 nft = IERC721(nftcontract_);
          require(nft.ownerOf(tokenid_) == msg.sender, "you do not own this nft");

      } else if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

          IERC1155 nft = IERC1155(nftcontract_);
          require(nft.balanceOf(msg.sender, tokenid_) > 0, "you do not own this nft");

      } else {

          revert("invalid nft address");
      }

      _unlockdate = untiltime_;

    }
}

contract USERWALLET is ERC721Holder, ERC1155Holder {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    event deposit(
        address sender,
        uint256 amount,
        address x0
    );
    event withdraw(

        address receiver,
        uint256 amount,
        address x0
    );
    bytes4 private constant INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant INTERFACE_ID_ERC1155 = 0xd9b67a26;
    mapping(address => bool) public _backupaccess;
    uint256 public _unlockdate;
    bool private _backupaccessonly;
    bool private _backupaccessadded;
    address private _owner;
    string public _name;
    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    constructor(address owner_, string memory name_) {
      _owner = owner_;
      _name = name_;
    }

    receive () external payable {}

    function addbackupaccess(address backup_) public {

      if(_backupaccessadded){

        require(_backupaccess[msg.sender], 'add from backup access');

      }else{

        require(msg.sender == _owner, 'you are not the owner of this wallet');

      }

      _backupaccess[backup_] = true;
      _backupaccessadded = true;

    }

    function turnonbackupaccess() public {

      require(_backupaccess[msg.sender] || msg.sender == _owner, 'you cannot do that');
      _backupaccessonly = true;

    }

    function turnoffbackupaccess() public {

      require(_backupaccess[msg.sender] , 'use back up access');
      _backupaccessonly = false;

    }

    function holdnft(address nftcontract_, uint256 tokenid_, uint256 quantity_) public {

        require(msg.sender == _owner, 'you are not the owner of this wallet');

      if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

          IERC721 nft = IERC721(nftcontract_);
          require(nft.ownerOf(tokenid_) == msg.sender, "you do not have this");
          require(nft.isApprovedForAll(msg.sender, address(this)), "item not approved");
          nft.safeTransferFrom(msg.sender, address(this), tokenid_);

      } else if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

          IERC1155 nft = IERC1155(nftcontract_);
          require(nft.balanceOf(msg.sender, tokenid_) >= quantity_, "you have nnot enough");
          nft.safeTransferFrom(msg.sender, address(this), tokenid_, quantity_, bytes(""));

      } else {

          revert("invalid nft address");
      }

    }

    function transfernft(address nftAddress_, uint256 tokenid_, uint256 quantity_) public {

        if(!_backupaccessonly){

          require(msg.sender == _owner, 'you are not the owner of this wallet');

        }else{

          require(_backupaccess[msg.sender], 'you do not have access');

        }
        require(block.timestamp > _unlockdate, 'wallet is locked');

      if (IERC165(nftAddress_).supportsInterface(INTERFACE_ID_ERC721)) {

          IERC721 nft = IERC721(nftAddress_);
          require(nft.ownerOf(tokenid_) == address(this), "not in wallet");
          require(nft.isApprovedForAll(msg.sender, address(this)), "item not approved");

      } else if (IERC165(nftAddress_).supportsInterface(INTERFACE_ID_ERC1155)) {

          IERC1155 nft = IERC1155(nftAddress_);
          require(nft.balanceOf(address(this), tokenid_) >= quantity_, "must hold enough in wallet");
          nft.safeTransferFrom(address(this), msg.sender, tokenid_, quantity_, bytes(""));

      } else {

          revert("invalid nft address");
      }
    }

    function withdraweth() public returns(bool){

      if(!_backupaccessonly){

        require(msg.sender == _owner, 'you are not the owner of this wallet');

      }else{

        require(_backupaccess[msg.sender], 'you do not have access');

      }

        require(block.timestamp > _unlockdate, 'wallet is locked');
        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        return success;


    }

    function transfertoken(address token_, uint256 value_) public {

      if(!_backupaccessonly){

        require(msg.sender == _owner, 'you are not the owner of this wallet');

      }else{

        require(_backupaccess[msg.sender], 'you do not have access');

      }
      require(block.timestamp > _unlockdate, 'wallet is locked');
      require(msg.sender == _owner || _backupaccess[msg.sender], 'you are not the owner of this wallet');
      require(IERC20(token_).balanceOf(address(this))>0 , 'no balance');
      IERC20(token_).safeTransfer(msg.sender,value_);

    }

    function lockwallet(uint256 untiltime_) public {

      if(!_backupaccessonly){

        require(msg.sender == _owner, 'you are not the owner of this wallet');

      }else{

        require(_backupaccess[msg.sender], 'you do not have access');

      }

      _unlockdate = untiltime_;

    }
}

contract FERRO_WALLETS  {

    mapping(uint256=>mapping(address=>address)) public _nftid2nftcontract2wallet;
    address[] public _nftwallets;
    mapping(address => address) private _user2wallet;
    mapping(address => address[]) public _user2wallets;

   constructor() {}

  function CREATEUSERWALLET(address user_, string memory name_) public returns(address) {

    address wallet_ = address(new USERWALLET(user_, name_));
    if(_user2wallet[user_]==address(0)){

      _user2wallet[user_] = wallet_;

    }
    _user2wallets[user_].push(wallet_);

    return wallet_;

  }

  function CREATENFTWALLET(address nftcontract_, uint256 nftid_) public returns(address) {

    require(_nftid2nftcontract2wallet[nftid_][nftcontract_] == address(0), 'wallet already created');

    address wallet_ = address(new NFTWALLET(nftcontract_, nftid_));
    require(wallet_!=address(0), 'error creating wallet');

    _nftid2nftcontract2wallet[nftid_][nftcontract_] = wallet_;
    _nftwallets.push(wallet_);

    return wallet_;

  }

  function GETNFTWALLET(address nftcontract_, uint256 nftid_) public view returns(address, address[] memory) {

    return (_nftid2nftcontract2wallet[nftid_][nftcontract_], _nftwallets);

  }

  function GETUSERWALLET(address user_) public view returns(address, address[] memory) {

    return (_user2wallet[user_], _user2wallets[user_]);

  }
}
