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
interface i369 {

  function GETNFTTOWRAP(uint256 nftid_) external pure returns(uint256,uint256[] memory);
  function GETUSERWALLET(address user_) external returns(address, address[] memory);
  function CREATENFTWALLET(address nftcontract_, uint256 nftid_) external returns(address);

}
contract TELL_A_FRIEND_NFTS is Ownable, ERC1155, ERC1155Burnable, ERC1155Supply, ReentrancyGuard {

    using Address for address;
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    event newnftmint(
        address creator,
        uint256 nftid,
        string ipfs
    );
    event newcollection(
        address creator,
        uint256 collectionid
      );
    event newattribute(

      uint256 tokenid,
      string name,
      string representation,
      string category,
      uint256 supply,
      uint256 pricedto

    );
    event newtokenmint(

        uint256 tokenid,
        uint256 amount,
        address holder

    );
    struct COLLECTIONS{

      uint256 id;
      string title;
      string details;
      string image;
      string media;
      address creator;
      uint256 category;
      uint256[] nfts;
    }
    COLLECTIONS[] public _collections;
     struct NFTS{

       uint256 id;
       address payto;
       uint256 category;
       uint256 mint;
       uint256 redeems;
       uint256 royalty;
       uint256 collection;
       uint256 mintamount;
       string ipfs;
       address wallet;

     }

     NFTS[] public _nfts;
     struct ATTRIBUTES{

       uint256 tokenid;
       string name;
       string representation;
       string category;
       uint256 supply;
       uint256 pricedto;
       string uri;
     }
     ATTRIBUTES[] public _attributes;
     mapping(uint256=>uint256) public _attribute2index;
     mapping(uint256=>ATTRIBUTES) public _attribute;
     mapping(string=>uint256[]) public _attributecategory2tokens;
     mapping(string=>ATTRIBUTES) public _attibutename2attribute;
     mapping(uint256=>NFTS) public _nft;
     mapping(uint256=>COLLECTIONS) public _collection;
     mapping(uint256=> string[]) public _collection2mediaurl;
     mapping(uint256=>uint256) public _nft2collectionindex;
     mapping(address=>bool) public _isjordi;
     mapping(address=>bool) public _isdata;
     mapping(address=>bool) public _batchmintapproved;
     mapping(address=>mapping(uint256=>bool)) public _approved2mint2collection;
     mapping(address=>uint256[]) public _user2collections;
     mapping(address=>mapping(uint256=>uint256)) private _user2collections2index;
     mapping(string=>uint256[]) public _keyword2nft;

     uint256 public NFTID;
     uint256 public COLLECTIONID;
     address public NFTWRAPPER;
     address public NFTMARKET;
     address public BANK;
     address public WALLETS;
     uint256 public FERRO;

    address public _burn = 0x000000000000000000000000000000000000dEaD;

    constructor(string memory name_, string memory category_, string memory respresentation_, uint256 supply_, string memory uri_, address bank_) ERC1155("https://tellafriend.eth/nft/{id}.json") {

      NFTID = 1;
      COLLECTIONID = 0;
      BANK = bank_;

      ATTRIBUTES memory save_ = ATTRIBUTES({
        tokenid: NFTID,
        name: name_,
        representation: respresentation_,
        category: category_,
        supply: supply_,
        pricedto: 0,
        uri: uri_
      });
      _attributes.push(save_);
      _attribute2index[NFTID] = _attributes.length -1;
      _attribute[NFTID] = save_;
      _attributecategory2tokens[category_].push(NFTID);
      FERRO = NFTID;
      _mint(bank_, NFTID, 1000000*10**18, '');
      _isjordi[msg.sender] = true;
      _isdata[msg.sender] = true;

    }

    function ISSUENEWMINT(address to_, uint256 amount_, uint256 tokenid_) public returns (bool){

      require(_isdata[msg.sender], 'you cannot do that');

      (address ferrowallet_,) = i369(WALLETS).GETUSERWALLET(to_);
      require(ferrowallet_!=address(0), 'create your ferro wallet');

      uint256 burned_ = balanceOf(_burn, tokenid_);
    //   uint256 liquidity_ = balanceOf(BANK, tokenid_);
      uint256 supply_ = _attribute[tokenid_].supply;
    //   uint256 minttobank_= liquidity_.div(totalSupply(tokenid_)).mul(100);

      bool success;

      if(tokenid_==1){

        if(burned_.add(amount_)>supply_){

          amount_ = supply_.sub(burned_);

        }

      }else{

        if(burned_.add(amount_)>supply_){

          amount_ = supply_.sub(burned_);

        }
      }

      require(amount_ > 0, 'supply limit reached');
      _mint(ferrowallet_, tokenid_, amount_, '');
      return success;

    }

    function setmintpromonft(uint256 nftid_, uint256 tokentomint_, uint256 amounttomint_) public {
      ///// this allows an nft to mint mor attributes tokens to the owner of the nft

      require(_isjordi[msg.sender], 'you are not that guy');
      require(amounttomint_.add(totalSupply(tokentomint_)) < _attributes[tokentomint_].supply, 'over supply');

      _nft[nftid_].mint = tokentomint_;
      _nft[nftid_].mintamount = amounttomint_;
      _nft[nftid_].redeems = 1;

    }

    function setattributetoken(string memory name_, string memory category_, string memory respresentation_, uint256 supply_, string memory uri_, uint256 pricedto_) public {
      ////creats an attribute tokens
      require(_isjordi[msg.sender], 'you are not that guy');

      NFTID +=1;
      supply_ = supply_*10**18;

      ATTRIBUTES memory save_ = ATTRIBUTES({
        tokenid: NFTID,
        name: name_,
        representation: respresentation_,
        category: category_,
        supply: supply_,
        pricedto: pricedto_,
        uri: uri_
      });
      _attributes.push(save_);
      _attribute[NFTID] = save_;
      _attributecategory2tokens[category_].push(NFTID);
      _mint(msg.sender, NFTID, 1, '');

    }

    function deleteattribute(uint256 id_) public {

      require(_isjordi[msg.sender], 'you are not that guy');

      delete _attributes[_attribute2index[id_]];

    }

    function GETCIRCULATINGSUPPLY(uint256 tokenid_) public view returns(uint256, uint256, uint256){

      // uint256 supply_ = totalSupply(tokenid_);
        uint256 ferro_ = totalSupply(1).sub(balanceOf(_burn,1));
        uint256 alltokenssupply_ = 0;
        uint256 tokensupply_ = 0;

      if(tokenid_!=1){

          tokensupply_ = totalSupply(tokenid_).sub(balanceOf(_burn,tokenid_));


        for (uint256 i = 0; i<_attributes.length; i++){

          alltokenssupply_ += totalSupply(_attributes[i].supply).sub(balanceOf(_burn,_attributes[i].tokenid));
        }

        alltokenssupply_ = tokensupply_.add(alltokenssupply_);
      }
      return (ferro_, tokensupply_, alltokenssupply_);
    }

    function GETPRICEDTOSWAPSUPPLY(uint256 tokenin_, uint256 tokenout_) public view returns(uint256, uint256, uint256, uint256, uint256, uint256) {

      uint256 tokeninispriceto_ = _attributes[tokenin_].pricedto;
      uint256 tokenoutispriceto_ = _attributes[tokenout_].pricedto;

      uint256 tokeninpricedtosupply_ = totalSupply(tokeninispriceto_).sub(balanceOf(_burn,tokeninispriceto_));
      uint256 tokenoutpricedtosupply_ = totalSupply(tokenoutispriceto_).sub(balanceOf(_burn,tokenoutispriceto_));

      uint256 tokeninsupply_ = totalSupply(tokenin_).sub(balanceOf(_burn,tokenin_));
      uint256 tokenoutsupply_ = totalSupply(tokenout_).sub(balanceOf(_burn,tokenout_));

      return(tokeninsupply_, tokenoutsupply_, tokeninpricedtosupply_, tokenoutpricedtosupply_, tokeninispriceto_, tokenoutispriceto_);
    }

    function GETPRICEDTOSUPPLY(uint256 tokenid_) public view returns(uint256, uint256, uint256, uint256,uint256) {

      uint256 ispricedto_ = _attributes[tokenid_].pricedto;
      uint256 ferro_ = totalSupply(1).sub(balanceOf(_burn,1));
      uint256 wura_ = totalSupply(2).sub(balanceOf(_burn,2));
      uint256 ispricedtotokensupply_ = totalSupply(ispricedto_).sub(balanceOf(_burn,ispricedto_));
      uint256 tokensupply_ = totalSupply(tokenid_).sub(balanceOf(_burn,tokenid_));

      return(ferro_, wura_, tokensupply_, ispricedto_, ispricedtotokensupply_);

    }

    function GETTOKENCIRCULATINGSUPPLY(uint256 tokenid_) public view returns(uint256) {

      return totalSupply(tokenid_).sub(balanceOf(_burn,tokenid_));

    }

    function setcontracts(address market_, address wrapper_, address bank_, address wallet_) public {

        require(_isjordi[msg.sender], 'you are not that guy');
        NFTMARKET = market_;
        NFTWRAPPER = wrapper_;
        BANK = bank_;
        WALLETS = wallet_;

    }
    function setdata(address data_, bool value_) public {

        require(_isjordi[msg.sender], 'you are not that guy');
        _isdata[data_] = value_;
    }

    function setURI(string memory newuri) internal returns(bool){

        _setURI(newuri);
        return true;
    }

    function setcollection(string memory title_, string memory details_, string memory image_, string memory media_, uint256 category_) public {

      COLLECTIONID += 1;
      COLLECTIONS memory save_ = COLLECTIONS({
        id: COLLECTIONID,
        title:title_,
        details:details_,
        image: image_,
        media: media_,
        creator: msg.sender,
        category: category_,
        nfts: new uint256[](0)
      });
      _collection[COLLECTIONID] = save_;
      _collections.push(save_);
      _user2collections[msg.sender].push(COLLECTIONID);
      _user2collections2index[msg.sender][COLLECTIONID] = _user2collections[msg.sender].length - 1;
      emit newcollection(msg.sender, COLLECTIONID);

    }

    function collectiondelete(uint256 collection_) public {

      require(_collection[collection_].creator == msg.sender, 'you do not own this collection');
      delete _user2collections[msg.sender][_user2collections2index[msg.sender][COLLECTIONID]];

    }

    function getcollections(address user_) public view returns (uint256[] memory){

      return _user2collections[user_];
    }

    function getcollection(uint256 collectionid_) public view returns (COLLECTIONS memory){

      return _collection[collectionid_];
    }

    function setpromominter(uint256 collection_, address minter_, bool value_) public {

      require(_collection[collection_].creator == msg.sender, 'you do not own this collection');
      _approved2mint2collection[minter_][collection_] = value_;

    }

function setnftmint(bytes memory data_, string memory ipfs_, uint256 collection_, uint256 royalty_, uint256 prints_, address payto_, uint256 redeems_, uint256 category_ ) public
    {
      require(_collection[collection_].creator == msg.sender || _approved2mint2collection[msg.sender][collection_], 'you are not approved to mint to this collection');

      NFTID += 1;

      bool success = setURI(ipfs_);
      require(success, 'error setting uri');
      address wallet_;
      if(prints_==1){
      (wallet_) = i369(WALLETS).CREATENFTWALLET(address(this),NFTID);

      }else{
          wallet_ = address(0);
      }

      NFTS memory save_ = NFTS({

        id:NFTID,
        category: category_,
        mint: 0,
        mintamount: 0,
        redeems: redeems_,
        royalty: royalty_,
        collection: collection_,
        payto: payto_,
        ipfs: ipfs_,
        wallet:wallet_
      });

      _nft[NFTID] = save_;
      _nfts.push(save_);
      _collection[collection_].nfts.push(NFTID);
      _nft2collectionindex[NFTID] = _collection[collection_].nfts.length - 1;
      _mint(_collection[collection_].creator, NFTID, prints_, data_);
      emit newnftmint(msg.sender, NFTID, ipfs_);

    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public {
        require(_batchmintapproved[msg.sender], ' you are not that cool');
        _mintBatch(to, ids, amounts, data);
    }

    function CHECKCOUPON(uint256 nftid_) public view returns (bool,uint256,uint256){

      bool iscoupon_;
      (uint256 wrappedto_,) = i369(NFTWRAPPER).GETNFTTOWRAP(nftid_);

      if(wrappedto_>0){

        nftid_ = wrappedto_;

      }

      if(_nft[nftid_].category==3){

        iscoupon_ = true;

      }
      return (iscoupon_,_nft[nftid_].mint, _nft[nftid_].mintamount);
    }

    function setnftkeyword(string memory keyword_, uint256 nftid_) public {

      require(balanceOf(msg.sender, nftid_)>0, 'you do not own this nft');
      _keyword2nft[keyword_].push(nftid_);

    }

    function getnftbykeyword(string memory keyword_) public view returns(uint256[] memory){

        return _keyword2nft[keyword_];
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
            internal
            override(ERC1155, ERC1155Supply)
    {
            super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

}
