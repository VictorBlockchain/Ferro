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

contract FERRO_BANK is ERC721Holder, ERC1155Holder {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    event swapethferro(
        address tokenin,
        uint256 tokenout,
        uint256 tokeninamount,
        uint255 tokenoutamount,
        address holder
    );
    event swapferroeth(
        uint256 tokenin,
        address tokenout,
        uint256 tokeninamount,
        uint255 tokenoutamount,
        address holder
    );
    event swaptoken(
        uint256 tokenin,
        uint256 tokenout,
        uint256 tokeninamount,
        uint255 tokenoutamount,
        address holder
    );
    event swapstop(
        uint256 date,
    );

    bytes4 private constant INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant INTERFACE_ID_ERC1155 = 0xd9b67a26;
    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    mapping(address=>bool) private _isjordi;
    mapping(address=>bool) private _isdata;
    mapping(address=>uint256) public _swaptimeout;
    mapping(uint256=>bool) public _isapprovedswapnft;
    bool _swapstop;
    uint256 _swapstopdate;
    uint256 _lockafter;
    uint256 _ferro;
    uint256 _wura;

    address public _burn = 0x000000000000000000000000000000000000dEaD;
    address public NFT;
    address public FAMILY;
    address private _marketing;

     constructor(address nft_, address family_, uint256 ferro_, uint256  wura_) {

       NFT = nft_;
       FAMILY = family_;
       _ferro = ferro_;
       _wura = wura_;
      _isjordi[msg.sender] = true;
      _swapstop = false;
      _lockafter = block.timestamp + 90 days;

     }

  receive () external payable {}

    function setapprovedswapnft(uint256 nftid_, bool value_) public {

        require(_isjordi[msg.sender], 'you are not that guy');
        _isapprovedswapnft[nftid_] = value_;
    }

    function getethliquidity() internal returns (uint256){

      return IERC20(WETH).balanceOf(address(this));

    }

    function getpricedtoswapsupply(uint256 tokenout_, uint256 tokenin_) internal view returns(uint256, uint256, uint256, uint256, uint256, uint256,uint256,uint256){

     return i369(NFT).GETPRICEDTOSWAPSUPPLY(tokenout_, tokenin_);

    }

    function priceferro() internal view returns(uint256, uint256,uint256, uint256) {

        uint256 liquidityferro_ = IERC1155(NFT).balanceOf(address(this), _ferro);
        uint256 liquiditywura_ = IERC1155(NFT).balanceOf(address(this), _wura);

       return (getethliquidity().div(i369(NFT).GETCIRCULATINGSUPPLY(_ferro)), liquidityferro_, liquidityferro_.div(i369(NFT).GETCIRCULATINGSUPPLY(_wura)),liquiditywura_);
    }

    function pricetokenout(uint256 tokenin_, uint256 tokenout_) internal view returns(uint256, uint256) {

        (, , , uint256 tokenoutsupply_, ,, uint256 tokeninispricedto_, uint256 tokenoutispricedto_ ) = i369(NFT).GETPRICEDTOSWAPSUPPLY(tokenin_,tokenout_);
        (, , , uint256 liquiditywura_) = priceferro();
        uint256 tokenoutprice_;

        if(tokeninispricedto_!=_wura && tokeninispricedto_!=_ferro){

        (, , , ,uint256 pricedtotokensupply1_) = i369(NFT).GETPRICEDTOSUPPLY(tokeninispricedto_);

        uint256 liquiditytokeninispricedto_ = IERC1155(NFT).balanceOf(address(this), tokeninispricedto_);
        uint256 priceoftokeninispricedto_ = liquiditywura_.div(pricedtotokensupply1_);
                liquiditytokeninispricedto_ = liquiditytokeninispricedto_.mul(priceoftokeninispricedto_);
                require(liquiditytokeninispricedto_ > 0, 'not enough token liqudity to price out token in swap');
                  tokeninprice_ = liquiditytokeninispricedto_.div(tokeninsupply_);

        }
        if(tokenoutispricedto_!=_wura && tokenoutispricedto_!=_ferro){

        (, ,,, uint256 pricedtotokensupply3_) = i369(NFT).GETPRICEDTOSUPPLY(tokenoutispricedto_);

        uint256 liquiditytokenoutispricedto_ = IERC1155(NFT).balanceOf(address(this), tokenoutispricedto_);
        uint256 priceoftokenoutispricedto_ = liquiditywura_.div(pricedtotokensupply3_);
                liquiditytokenoutispricedto_ = liquiditytokenoutispricedto_.mul(priceoftokenoutispricedto_);
                require(liquiditytokenoutispricedto_ > 0, 'not enough token liqudity to price out token in swap');
                tokenoutprice_ = liquiditytokenoutispricedto_.div(tokenoutsupply_);

        }
        return (tokeninprice_,tokenoutprice_);
    }

    function swapferroforeth(uint256 sellamount_) public returns(bool){

    ///swap ferro for eth only... 10% fee applies
    require(!_swapstop, 'swaps stopped');

    require(IERC1155(NFT).balanceOf(msg.sender, _ferro) >= sellamount_, 'you do not have that many ferro');

    (uint256 circulatingferro_) = i369(NFT).GETCIRCULATINGSUPPLY(_ferro);

    uint256 ferroprice_ = getethliquidity().div(circulatingferro_);
    uint256 liquidity_ = sellamount_.mul(4).div(100);
    uint256 familyfee_ = sellamount_.mul(2).div(100);
    uint256 servicefee_ = sellamount_.mul(4).div(100);
    uint256 ethamount_ = sellamount_.sub(liquidity_).sub(familyfee_).sub(servicefee_);
            ethamount_ = sellamount_.mul(ferroprice_);

            require(getethliquidity() > ethamount_, 'not enough eth liquidity to swap');
            IERC1155(NFT).safeTransferFrom(msg.sender,address(this), _ferro, sellamount_, '');
            require(checkSuccess(), 'error transferring tokens to swap for eth');

            IERC20(WETH).safeTransfer(msg.sender, ethamount_);
            require(checkSuccess(), 'error sending eth of swap');

            IERC1155(NFT).safeTransferFrom(address(this),_burn, _ferro, sellamount_.div(2), '');
            require(checkSuccess(), 'error burning half of swap');///burn half of swapped ferror
            if(FAMILY!=address(0)){

              (address family_, address familyleader_ ) = i369(FAMILY).GETFAMILY(msg.sender);

              if(family_!=address(0) && familyleader_!=address(0)){

                IERC1155(NFT).safeTransferFrom(address(this),family_, _ferro, familyfee_.div(2), '');
                require(checkSuccess(), 'error burning half of swap');///burn half of swapped ferror
                IERC1155(NFT).safeTransferFrom(address(this),familyLeader_, _ferro, familyfee_.div(2), '');
                require(checkSuccess(), 'error burning half of swap');///burn half of swapped ferror

              }
            }
            IERC20(WETH).safeTransfer(_marketing, servicefee_);
            require(checkSuccess(), 'error sending eth of swap');


    return success;
  }

  function swapethforferro(uint256 buyamount_) public {

    ///swap eth for ferro token only... 8% fee applies
    require(!_swapstop, 'swaps stopped');

    require(IERC1155(NFT).balanceOf(address(this), _ferro) > 0, 'not enough token liquidity');
    (uint256 circulatingferro_) = i369(NFT).GETCIRCULATINGSUPPLY(_ferro);

      uint256 ferroprice_ = getethliquidity().div(circulatingferro_);
      uint256 liquidity_ = buyamount_.mul(3).div(100);
      uint256 familyfee_ = buyamount_.mul(2).div(100);
      uint256 servicefee_ = buyamount_.mul(3).div(100);
      uint256 ethamount_ = buyamount_.sub(liquidity_).sub(familyfee_).sub(servicefee_);
              ethamount_ = ethamount_.div(ferroprice_);

      IERC20(WETH).safeTransferFrom(msg.sender,address(this), buyamount_);
      require(checkSuccess(), 'error paying swap');
      IERC1155(NFT).safeTransferFrom(address(this), msg.sender, _ferro, tokenamount_, '');
      require(checkSuccess(), 'error sending tokens swaped for eth');
      if(FAMILY!=address(0)){

        (address family_, address familyleader_ ) = i369(FAMILY).GETFAMILY(msg.sender);

        if(family_!=address(0) && familyleader_!=address(0)){

          IERC1155(NFT).safeTransferFrom(address(this),family_, _ferro, familyfee_.div(2), '');
          require(checkSuccess(), 'error burning half of swap');///burn half of swapped ferror
          IERC1155(NFT).safeTransferFrom(address(this),family_, _ferro, familyLeader_.div(2), '');
          require(checkSuccess(), 'error burning half of swap');///burn half of swapped ferror

        }
      }
      IERC20(WETH).safeTransfer(_marketing, servicefee_);
      require(checkSuccess(), 'error sending eth of swap');

  }

  function swapattributeforattribute(uint256 tokenin_, uint256 tokenout_, uint256 sellamount_) public {

    //swap any attribute token for another
    require(!_swapstop, 'swaps stopped');
    require(tokenin_!=tokenout_, 'cannot swap same tokens');
    require(tokenin_!=_ferro && tokenout_!=_ferro, 'cannot swap same tokens');
    require(_isapprovedswapnft[tokenin_] && _isapprovedswapnft[tokenout_], 'this token is not approved to swap');
    /// calculate token out price... get the token its priced to

    (, , , uint256 tokenoutsupply_, ,, , uint256 tokenoutispricedto_ ) = i369(NFT).GETPRICEDTOSWAPSUPPLY(tokenout_,tokenin_);
    (, uint256 liquidityferro_, , uint256 liquiditywura_) = priceferro();

    (uint256 tokeninprice_,uint256 tokenoutprice_) = pricetokenout(tokenin_,tokenout_);

    if (tokenoutispricedto_==_wura){
      require(liquiditywura_ > 0, 'not enough wura liqudity to price out token in swap');
      tokenoutprice_ = liquiditywura_.div(tokenoutsupply_);
    }

   if (tokenoutispricedto_==_ferro){

      require(liquidityferro_ > 0, 'not enough ferro liqudity to price out token in swap');
      tokenoutprice_ = liquidityferro_.div(tokenoutsupply_);

    }
      uint256 amountout_ = sellamount_.sub(familyfee_).mul(tokeninprice_);
              amountout_ = amountout_.div(tokenoutprice_);
              uint256 familyfee_ = amountout_.mul(3).div(100);


      require(IERC1155(NFT).balanceOf(address(this),tokenout_) > amountout_, 'not enough liquidity token out')
      IERC1155(NFT).safeTransferFrom(msg.sender, address(this), tokenin_, sellamount_, '');
      require(checkSuccess(), 'error swaping tokens in');

      IERC1155(NFT).safeTransferFrom(address(this), msg.sender, tokenout_, amountout_.sub(familyfee_), '');
      require(checkSuccess(), 'error swapping tokens out');

      if(FAMILY!=address(0)){

        (address family_, address familyleader_ ) = i369(FAMILY).GETFAMILY(msg.sender);

        if(family_!=address(0) && familyleader_!=address(0)){

          IERC1155(NFT).safeTransferFrom(address(this),family_, tokenout_, familyfee_, '');
          require(checkSuccess(), 'error burning half of swap');///burn half of swapped ferror

        }
      }
      IERC1155(NFT).safeTransferFrom(address(this), _burn, tokenin_, sellamount_.div(2), '');
      require(checkSuccess(), 'error burning tokens in');


  }

//   function gettokenprice(uint256 tokenid_) public returns(uint256, uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256){

//     (uint256 ferrosupply_, uint256 wurasupply_, uint256 tokensupply_, , ) = i369(NFT).GETPRICEDTOSUPPLY(tokenid_);
//     uint256 pricedtotoken_;
//     uint256 pricedtotokensupply_;

//     uint256 ferro_ = 1;
//     uint256 wura_ = 2;

//     uint256 pricetoken_;
//     uint256 marketcaptoken_;
//     uint256 liquidityeth_ = getethliquidity();
//     uint256 liquiditytoken_ = IERC1155(NFT).balanceOf(address(this), tokenid_);

//     uint256 priceferro_ = getethliquidity().div(ferrosupply_);
//     uint256 liquidityferro_ = IERC1155(NFT).balanceOf(address(this), ferro_).mul(priceferro_);
//     uint256 marketcapferro_ = ferrosupply_.mul(priceferro_);

//     uint256 pricewura_ = liquidityferro_.div(wurasupply_);
//     uint256 liquiditywura_ = IERC1155(NFT).balanceOf(address(this), wura_).mul(pricewura_);
//     uint256 marketcapwura_ = wurasupply_.mul(pricewura_);

//     if(pricedtotoken_==_wura){

//       pricetoken_ = liquiditywura_.div(tokensupply_);
//       marketcaptoken_ = pricetoken_.mul(tokensupply_);

//     }else if(pricedtotoken_!=_wura && pricedtotoken_!=_ferro){

//       (, , uint256 pricedtotokensupply_, uint256 ispriced2token_, uint256 ispriced2tokensupply_) = i369(NFT).GETPRICEDTOSUPPLY(pricedtotoken_);
//       uint256 pricedtotokenliquidity_ = IERC1155(NFT).balanceOf(address(this), pricedtotoken_);
//       uint256 ispriced2tokenliquidity_ = IERC1155(NFT).balanceOf(address(this), ispriced2token_);

//       uint256 pricedtopricetoken_ = ispriced2tokenliquidity_.div(pricedtotokensupply_);
//               pricedtotokenliquidity_ = pricedtotokenliquidity_.mul(pricedtopricetoken_);

//               pricetoken_ = pricedtotokenliquidity_.div(tokensupply_);
//               marketcaptoken_ = pricetoken_.mul(tokensupply_);

//     }else if (pricedtotoken_==_ferro){

//       pricetoken_ = pricewura_;
//     }

//     return (liquidityeth_, priceferro_, liquidityferro_, marketcapferro_, pricewura_, liquiditywura_, marketcapwura_, pricetoken_, marketcaptoken_);

//   }

//   function cleanbank(address token_, address nftcontract_, uint256 nftid_) public {
//     require(!_swapstop, 'swaps stopped');

//       if(token_!=address(0)){

//         uint256 balance_ = IERC20(token_).balanceOf(address(this));
//         if(balance_>0){

//           IERC20(token_).safeTransfer(msg.sender, balance_);
//         }

//       }else{

//         require(!_isapprovedswapnft[nftid_], 'cannot clean approved tokens' );
//         require(IERC1155(NFT).balanceOf(address(this), nftid_) >0, 'nft is not here mate');
//         IERC1155(NFT).safeTransferFrom(address(this), msg.sender, nftid_, 1, '');
//         require(checkSuccess(), 'error swaping tokens in');

//       }
//   }

  function stopswap(bool value_) public {

    require(_isjordi[msg.sender], 'you are not that guy');
    _swapstop = value_;
    _swapstopdate = block.timestamp;

  }
  function checkSuccess()
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
