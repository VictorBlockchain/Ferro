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

  function ISSUENEWMINT(address to_, uint256 amount_, uint256 tokenid_) external returns (bool);
  function GETTRIBE(address user_) external returns (address, address);

}
contract NFT_TELLS is ERC721Holder, ERC1155Holder {

    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    struct TELLS{

      uint256 reserve;
      uint256 buyprice;
      uint256[] bids;
      uint256 endtime;
      address seller;
      address[] bidders;
      uint256 nftcategory;
      address nftcontroller; //ens contract or nft contract address
      uint256 nftid;
      uint256 prints;

    }

    TELLS[] public _tells;
    uint256[] public _activenfttells;
    uint256[] public _activeenstells;
    mapping(uint256=>uint256) public _activetell2index;

    mapping(uint256=>TELLS) public _tellid2tell;
    mapping(address=>uint256[]) public _teller2tells;
    mapping(uint256=>uint256) private _tell2index;
    mapping(address=>bool) private _isadmin;
    mapping(uint256=>address) private _nft2wallet;

    bytes4 private constant INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant INTERFACE_ID_ERC1155 = 0xd9b67a26;
    address public _ens = 0x000000000000000000000000000000000000dEaD;
    address public WETH = 0x000000000000000000000000000000000000dEaD;
    address public NFT;
    address public WALLETS;
    address public BANK;
    address public TRIBE;
    uint256 public _tellid;

     constructor(address bank_, address wallets_, address nft_, address tribe_) {

         NFT = nft_;
         WALLETS = wallets_;
         BANK = bank_;
         TRIBE = tribe_;
         _tellid = 0;

     }
     receive () external payable {}

     function createtell(address nftcontract_, uint256 nftid_, uint256 nftcategory_, uint256 prints_, uint256 reserveprice_, uint256 buyprice_, address nftwallet_) public {

       if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

           IERC721 nft = IERC721(nftcontract_);
           require(nft.ownerOf(nftid_) == msg.sender, "you do not have this nft");

           require(nft.isApprovedForAll(msg.sender, address(this)), "item not approved");
           nft.safeTransferFrom(msg.sender, address(this), nftid_);
           require(checksuccess(), 'error transfering nft');

       } else if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

           IERC1155 nft = IERC1155(nftcontract_);
           require(nft.balanceOf(msg.sender, nftid_) >= prints_, "you have nnot enough");
           nft.safeTransferFrom(msg.sender, address(this), nftid_, prints_, bytes(""));
           IERC1155Receiver(address(this)).onERC1155Received(nftcontract_,msg.sender,nftid_,prints_,'');


       } else {

           revert("invalid nft address");
       }

       _tellid = _tellid + 1;

       TELLS memory save_ = TELLS({

         reserve: reserveprice_,
         buyprice: buyprice_,
         bids:  new uint256[](0),
         endtime: block.timestamp + 7 days,
         seller: msg.sender,
         bidders: new address[](0),
         nftcategory: nftcategory_,
         nftcontroller: nftcontract_,
         nftid: nftid_,
         prints: prints_

       });

       _tells.push(save_);
       _tellid2tell[_tellid] = save_;
       _teller2tells[msg.sender].push(_tellid);
       _tell2index[_tellid] = _teller2tells[msg.sender].length - 1;
       _nft2wallet[nftid_] = nftwallet_;

       if(nftcontract_ == _ens){

         _activeenstells.push(_tellid);
         _activetell2index[_tellid] = _activeenstells.length - 1;

       }else{

         _activenfttells.push(_tellid);
         _activetell2index[_tellid] = _activenfttells.length - 1;

       }

     }

     function canceltell(uint256 tellid_) public {

       require(_tellid2tell[tellid_].seller == msg.sender || _isadmin[msg.sender], 'not your tell');
       require(_activetell2index[tellid_]>0 , 'tell is not active');
       require(_tellid2tell[tellid_].bidders.length<1, 'tell has bids');

       address nftcontract_ = _tellid2tell[tellid_].nftcontroller;
       uint256 nftid_ = _tellid2tell[tellid_].nftid;

       if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

           IERC721 nft = IERC721(nftcontract_);
           require(nft.ownerOf(nftid_) == address(this), "nft not in this contract");

           nft.safeTransferFrom(address(this), _tellid2tell[tellid_].seller, nftid_);
           require(checksuccess(), 'error transfering nft');

       } else if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

           IERC1155 nft = IERC1155(nftcontract_);
           require(nft.balanceOf(address(this), nftid_) >= _tellid2tell[tellid_].prints, "not enough prints in contract");
           nft.safeTransferFrom(address(this), _tellid2tell[tellid_].seller , nftid_, _tellid2tell[tellid_].prints, bytes(""));

       } else {

           revert("invalid nft address");
       }

       if(_activenfttells[_activetell2index[tellid_]]>0){

          delete _activenfttells[_activetell2index[tellid_]];

       }else{

         delete _activeenstells[_activetell2index[tellid_]];

       }

        delete _teller2tells[_tellid2tell[tellid_].seller ][_tell2index[tellid_]];

     }

     function bid(uint256 tellid_, uint256 bidamount_) public {

       require(_activetell2index[tellid_]>0 , 'tell is not active');
       require(_tellid2tell[tellid_].seller == msg.sender, 'no bidding on your tell');
       uint256 highestbidindex_ = _tellid2tell[tellid_].bids.length - 1;
       uint256 highestbid_ = _tellid2tell[tellid_].bids[highestbidindex_];

       uint256 highestbidderindex_ = _tellid2tell[tellid_].bidders.length - 1;
       address highestbidder_ = _tellid2tell[tellid_].bidders[highestbidderindex_];
       address nftcontract_ = _tellid2tell[tellid_].nftcontroller;
       uint256 nftid_ = _tellid2tell[tellid_].nftid;

       if(_tellid2tell[tellid_].bidders.length>0){

         require(bidamount_ > highestbid_, 'bid too low');

       }else{

         require(bidamount_ > _tellid2tell[tellid_].reserve, 'bid too low');

       }

       if(bidamount_ >= _tellid2tell[tellid_].buyprice){
         ///transfer nft to buyer

         if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

             IERC721 nft = IERC721(nftcontract_);
             require(nft.ownerOf(nftid_) == address(this), "nft not in this contract");

             nft.safeTransferFrom(address(this), msg.sender, nftid_);
             require(checksuccess(), 'error transfering nft');

         } else if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

             IERC1155 nft = IERC1155(nftcontract_);
             require(nft.balanceOf(address(this), nftid_) > 0, "not enough prints in contract");
             nft.safeTransferFrom(address(this), msg.sender , nftid_, 1, bytes(""));

         } else {

             revert("invalid nft address");
         }
       }

       //refund previous bidder
       if(highestbidder_!=address(0)){

         IERC20(WETH).transfer(highestbidder_, highestbid_);
         require(checksuccess(), 'error refunding bid');

       }
       //register bid
       IERC20(WETH).safeTransferFrom(msg.sender,address(this),bidamount_);
       require(checksuccess(), 'error paying bid');

       uint256 fee_ = bidamount_.mul(2).div(100);
       bidamount_ = bidamount_.sub(fee_);

       _tellid2tell[tellid_].bids.push(bidamount_);
       _tellid2tell[tellid_].bidders.push(msg.sender);
       // pay 1% to nft and bank       //pay 1% to nft wallet if exists
       if(_nft2wallet[nftid_]!=address(0)){

         IERC20(WETH).transfer(_nft2wallet[nftid_], fee_.div(2));
         require(checksuccess(), 'error paying nft wallet');
         IERC20(WETH).transfer(BANK, fee_.div(2));
         require(checksuccess(), 'error paying bank');
       }else{
         IERC20(WETH).transfer(BANK, fee_);
         require(checksuccess(), 'error paying bank');
       }
       //mint ferro to tribe
       (address tribe_, address tribeleader_) = i369(TRIBE).GETTRIBE(msg.sender);
       if(tribe_!=address(0)){

         i369(NFT).ISSUENEWMINT(tribe_, fee_.div(2).div(3), 1);
         require(checksuccess(), 'error minting to tribe');

         i369(NFT).ISSUENEWMINT(tribeleader_, fee_.div(2).div(3), 1);
         require(checksuccess(), 'error minting to tribe leader');

         i369(NFT).ISSUENEWMINT(BANK, fee_.div(2).div(3), 1);
         require(checksuccess(), 'error minting to tribe leader');

       }else{

         i369(NFT).ISSUENEWMINT(BANK, fee_.div(2), 1);
         require(checksuccess(), 'error minting to tribe leader');

       }
     }

     function bidaccept(uint256 tellid_) public {

       require(_activetell2index[tellid_]>0 , 'tell is not active');
       uint256 highestbidderindex_ = _tellid2tell[tellid_].bidders.length - 1;
       address highestbidder_ = _tellid2tell[tellid_].bidders[highestbidderindex_];

       uint256 highestbidindex_ = _tellid2tell[tellid_].bids.length - 1;
       uint256 highestbid_ = _tellid2tell[tellid_].bids[highestbidindex_];

       address nftcontract_ = _tellid2tell[tellid_].nftcontroller;
       uint256 nftid_ = _tellid2tell[tellid_].nftid;

       if(block.timestamp < _tellid2tell[tellid_].endtime){

         require(_tellid2tell[tellid_].seller == msg.sender, 'not your tell');

       }else{

         require(highestbidder_ == msg.sender, 'not are not the highest bidder');

       }

       if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC721)) {

           IERC721 nft = IERC721(nftcontract_);
           require(nft.ownerOf(nftid_) == address(this), "nft not in this contract");

           nft.safeTransferFrom(address(this), highestbidder_, nftid_);
           require(checksuccess(), 'error transfering nft');

       } else if (IERC165(nftcontract_).supportsInterface(INTERFACE_ID_ERC1155)) {

           IERC1155 nft = IERC1155(nftcontract_);
           require(nft.balanceOf(address(this), nftid_) > 0, "not enough prints in contract");
           nft.safeTransferFrom(address(this), highestbidder_ , nftid_, 1, bytes(""));

       } else {

           revert("invalid nft address");
       }
       // pay seller
       IERC20(WETH).safeTransfer(_tellid2tell[tellid_].seller,highestbid_);
       require(checksuccess(), 'error paying bid');

       // transfer nft to highestbidder_

     }

     function checksuccess()
         private pure
         returns (bool)
       {
         uint256 returnValue = 0;

         /* solium-disable-next-line security/no-inline-assembly */
         assembly {
           // check number of bytes returned from last function call
           switch returndatasize()

             // no bytes returned: assume success
             case 0x0 {
               returnValue := 1
             }

             // 32 bytes returned: check if non-zero
             case 0x20 {
               // copy 32 bytes into scratch space
               returndatacopy(0x0, 0x0, 0x20)

               // load those bytes into returnValue
               returnValue := mload(0x0)
             }

             // not sure what was returned: dont mark as success
             default { }

         }

         return returnValue != 0;
       }
}
